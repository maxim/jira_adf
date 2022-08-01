# frozen_string_literal: true

require_relative 'jira_adf/version'

# A simple ADF (Atlassian Document Format) builder.
#
# Usage example:
#
#   result = JiraAdf {
#     # Keyword args become "attrs".
#     heading(level: 3) { text('An h3 heading') }
#
#     ordered_list {
#       list_item { paragraph { text('Paragraph in listItem') } }
#       list_item {
#         paragraph {
#           text('Text with ')
#
#           # Methods chained at the end of the node become "marks". Their
#           # keyword args become "attrs" of the mark.
#           text('bold and superscript').strong.subsup(type: 'sub')
#
#           text(' styling in the middle.')
#         }
#       }
#
#       # Use a regular lambda for snippet reuse. Keep in mind that due to how
#       # closures work, if you call this lambda in sub-nested scopes, it will
#       # still add an item in the scope where it was defined. And it will not
#       # exist at higher / neighbor scopes.
#       item = -> string { list_item { paragraph { text(string) } } }
#
#       # Now you can use shorter syntax.
#       item['Item 3']
#       item['Item 4']
#       item['Item 5']
#     }
#   }
#
#   result.to_h # => Ruby Hash ready for converting to JSON.
class JiraAdf
  class << self
    def format_hash(hash)
      hash.map { |k, v|
        key = camelize(k)

        [ key,

          if    key == 'type'; camelize(v)
          elsif Hash === v;    format_hash(v)
          elsif Symbol === v;  v.to_s
          else;                v
          end
        ]
      }.to_h
    end

    def camelize(term)
      term.to_s.gsub(/(?:^|_+)([^_])/) { $1.upcase }
        .tap { |s| s[0] = s[0].downcase }
    end
  end

  def initialize(node = { 'version' => 1, 'type' => 'doc' }, &block)
    @node = self.class.format_hash(node)
    instance_eval(&block) if block_given?

    # It's important that this variable is not yet set while instance_eval on
    # the previous line is being executed. This is how method_missing can
    # distinguish whether a method was called on a node, or it was called in an
    # instance_eval block. We use this fact to switch to adding `mark` fields
    # instead of `content` fields.
    @block_evaled_or_not_given = true
  end

  def to_h
    @node.transform_values { |v|
      case v
      when Array;      v.map { |e| self.class === e ? e.to_h : e }
      when Hash;       v.transform_values { |e| self.class === e ? e.to_h : e }
      when self.class; v.to_h
      else;            v
      end
    }
  end

  def method_missing(type, *args, **kwargs, &block)
    if @block_evaled_or_not_given
      hash = { 'type' => type }
      hash.merge! 'attrs' => kwargs if kwargs.any?
      @node['marks'] ||= []
      @node['marks'] << self.class.new(hash)
      self
    elsif type == :text
      self.class.new('type' => 'text', 'text' => args[0]).tap { |node|
        @node['content'] ||= []
        @node['content'] << node
      }
    else
      hash = { 'type' => type }
      hash.merge! 'attrs' => kwargs if kwargs.any?
      self.class.new(hash, &block).tap { |node|
        @node['content'] ||= []
        @node['content'] << node
      }
    end
  end
end

def JiraAdf(*args, **kwargs, &blk); JiraAdf.new(*args, **kwargs, &blk) end
