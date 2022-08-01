# frozen_string_literal: true

require_relative 'lib/jira_adf/version'

Gem::Specification.new do |spec|
  spec.name    = 'jira_adf'
  spec.version = JiraAdf::VERSION
  spec.authors = ['Max Chernyak']
  spec.email   = ['hello@max.engineer']


  spec.summary     = 'Builder-like syntax for Atlassian Document Format (ADF).'
  spec.description = 'Simple builder for making Atlassian Document Format ' \
                     '(ADF) look neat in Ruby.'
  spec.homepage    = 'https://github.com/maxim/jira_adf'
  spec.license     = 'MIT'

  spec.required_ruby_version         = '>= 2.7.0'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:bin|test|\.git)})
    end
  end

  spec.require_paths = ['lib']
end
