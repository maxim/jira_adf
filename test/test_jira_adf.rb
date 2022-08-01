# frozen_string_literal: true

require 'test_helper'

class TestJiraAdf < Minitest::Test
  def test_usage_example
    result = JiraAdf {
      heading(level: 3) { text('An h3 heading') }

      ordered_list {
        list_item { paragraph { text('Paragraph in listItem') } }
        list_item {
          paragraph {
            text('Text with ')
            text('bold and superscript').strong.subsup(type: 'sub')
            text(' styling in the middle.')
          }
        }

        rule

        item = -> string { list_item { paragraph { text(string) } } }
        item['Item 3']
        item['Item 4']
        item['Item 5']
      }
    }


    assert_equal(
      { "version" => 1,
        "type" => "doc",
        "content" => [
          { "type" => "heading",
            "attrs" => { "level" => 3 },
            "content" => [
              { "type" => "text", "text" => "An h3 heading" }
            ]
          },
          { "type" => "orderedList",
            "content" => [
              { "type" => "listItem",
                "content" => [
                  { "type" => "paragraph",
                    "content" => [
                      { "type" => "text", "text" => "Paragraph in listItem" }
                    ]
                  }
                ]
              },

              { "type" => "listItem",
                "content" => [
                  { "type" => "paragraph",
                    "content" => [
                      { "type" => "text", "text" => "Text with "},
                      { "type" => "text",
                        "text" => "bold and superscript",
                        "marks" => [ { "type" => "strong" },
                                     { "type" => "subsup",
                                       "attrs" => { "type" => "sub" } } ]
                      },
                      { "type" => "text", "text" => " styling in the middle." }
                    ]
                  }
                ]
              },

              { "type" => "rule" },

              { "type" => "listItem",
                "content" => [
                  { "type" => "paragraph",
                    "content" => [ { "type" => "text", "text" => "Item 3" } ]
                  }
                ]
              },

              { "type" => "listItem",
                "content" => [
                  { "type" => "paragraph",
                    "content" => [ { "type" => "text", "text" => "Item 4" } ]
                  }
                ]
              },

              { "type" => "listItem",
                "content" => [
                  { "type" => "paragraph",
                    "content" => [ { "type" => "text", "text" => "Item 5" } ]
                  }
                ]
              }
            ]
          }
        ]
      }, result.to_h)
  end

  def test_alternative_start_node
    result = JiraAdf(version: 3, type: 'doc2')
    assert_equal({ 'version' => 3, 'type' => 'doc2' }, result.to_h)
  end
end
