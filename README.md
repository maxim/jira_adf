# JiraAdf

[Atlassian Document Format](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/) is how Jira and friends format rich text. This tool helps you make those rich texts in ruby, with a neat builder-like syntax.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add jira_adf

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install jira_adf

## Usage

```ruby
result = JiraAdf {
  # Keyword args become "attrs".
  heading(level: 3) { text('An h3 heading') }

  ordered_list {
    list_item { paragraph { text('Paragraph in listItem') } }
    list_item {
      paragraph {
        text('Text with ')

        # Methods chained at the end of the node become "marks". Their
        # keyword args become "attrs" of the mark.
        text('bold and superscript').strong.subsup(type: 'sub')

        text(' styling in the middle.')
      }
    }

    # Use a regular lambda for snippet reuse. Keep in mind that due to how
    # closures work, if you call this lambda in sub-nested scopes, it will
    # still add an item in the scope where it was defined. And it will not
    # exist at higher / neighbor scopes.
    item = -> string { list_item { paragraph { text(string) } } }

    # Now you can use shorter syntax.
    item['Item 3']
    item['Item 4']
    item['Item 5']
  }
}

result.to_h # => Ruby Hash ready for converting to JSON.
```

If you want to specify custom doc type / version, you can pass args to the `JiraAdf` call.

```ruby
result = JiraAdf(version: 2, type: 'doc') { … }
result.to_h
```

To see an example of the hash it produces, check out the [test file](test/test_jira_adf.rb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxim/jira_adf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/jira_adf/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JiraAdf project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jira_adf/blob/main/CODE_OF_CONDUCT.md).
