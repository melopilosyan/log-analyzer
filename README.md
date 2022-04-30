# Log Analyzer

![](/screenshots/help-message.png?raw=true "Log Analyzer")<br/>

### Installation

Install Ruby 3.1.0. Clone the repo and

```bash
cd log-analyzer
bundle install
```

### Usage

The default format(total views counts) in default order(descending)
```bash
:$ ./parser webserver.log

/about/2 90 visits
/contact 89 visits
/index 82 visits
/about 81 visits
/help_page/1 80 visits
/home 78 visits
```

Format by unique page views counts in asending order:
```bash
:$ ./parser -f UV -o ASC webserver.log

/about 21 unique views
/about/2 22 unique views
/help_page/1 23 unique views
/contact 23 unique views
/home 23 unique views
/index 23 unique views
```

### Run tests with
```bash
rake test
```
