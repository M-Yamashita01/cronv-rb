# cronv-rb

A Ruby implementation of [cronv](https://github.com/takumakanari/cronv) (originally written in Go) that visualizes cron schedules from crontab as an interactive HTML timeline.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cronv-rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cronv-rb

## Usage

Pipe your crontab into `cronv` to generate an HTML timeline:

```sh
crontab -l | bundle exec ruby exe/cronv -o crontab.html
```

### Options

| Option | Description | Default |
|---|---|---|
| `-o`, `--output PATH` | Path to output HTML file | `./crontab.html` |
| `-d`, `--duration DURATION` | Duration to visualize (`1d` / `6h` / `30m`) | `6h` |
| `--from-date DATE` | Start date (`YYYY/MM/DD`) | Current date (UTC) |
| `--from-time TIME` | Start time (`HH:MM`) | Current time (UTC) |
| `-t`, `--title TITLE` | Title label of output | `Cron Tasks` |
| `-w`, `--width WIDTH` | Table width of output | `100` |

### Examples

```sh
# Visualize the next 24 hours starting from a specific date
crontab -l | bundle exec ruby exe/cronv \
  -o crontab.html \
  --from-date 2025/01/01 \
  --from-time 00:00 \
  -d 1d

# Visualize the next 30 minutes with a custom title
crontab -l | bundle exec ruby exe/cronv \
  -o crontab.html \
  -d 30m \
  -t "My Cron Jobs"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

```sh
bundle install
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/M-Yamashita01/cronv-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
