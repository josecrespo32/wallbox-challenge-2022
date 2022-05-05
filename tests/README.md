# Test Plans for wallbox-challenge-2022

The requested test plans are in the .feature files under the features folder:

```bash
features/
├── e2e
│   ├── admin.feature
│   └── user.feature
└── integration
    ├── assignments.feature
    ├── chargers.feature
    ├── signin.feature
    └── users.feature
```

The integration test plan is split in files by endpoints, and the e2e test plan by roles.

## Run tests with behave
You need the following software:
 - python 3 (developed with 3.10.4)
 - pip

Install python packages:
```bash
pip install -r requirements.txt
```
Run all the designed scenarios test against the application running in localhost:
```bash
behave features/integration/ features/e2e/
```
or run them against other host or ip
```bash
behave -D host=<host_or_ip> features/integration/ features/e2e/
```

## Generate a simple report
A simple csv report was developed.

Generate it running behave with the csv_report option:
```bash
behave -D csv_report features/integration/ features/e2e/
```

The report will be generated under reports every each behave execution:
```bash
reports
├── execution_report_20220504210605.csv
├── execution_report_20220504211354.csv
├── execution_report_20220504221307.csv
├── execution_report_20220504224134.csv
├── execution_report_20220504224334.csv
├── execution_report_20220504224433.csv
├── execution_report_20220504224615.csv
├── execution_report_20220504225003.csv
├── execution_report_20220504225037.csv
├── execution_report_20220504225208.csv
├── execution_report_20220504225618.csv
├── execution_report_20220504225635.csv
├── execution_report_20220504230119.csv
├── execution_report_20220504233811.csv
└── execution_report_20220504233951.csv
```

## Run tests in a docker-compose

Run all the tests in a docker-compose having inside the wallbox_challenge and the wallbox_tester services and it will generate also the csv report

You need docker and docker-compose installed in your system.

Then build the docker images:

```bash
docker-compose --profile all build
```

And start up:

```bash
docker-compose --profile all up -d
```

To stop and remove the containers created:

```bash
docker-compose --profile all down --volumes --remove-orphans
```

## Too much complex ??

Build and run up the docker-compose using the Makefile and get the csv report:
```bash
make qa-wallbox-up
```

These are the available commands
```bash
$ make help
Usage: make <command>
Commands:
  help:             Show this help information
  qa-wallbox-build:    Build the environment with a docker-compose
  qa-wallbox-up:       Build and launch the environment with a docker-compose
  qa-wallbox-down:     Stop the environment
```

## Issues

The detected bugs and comments are set as a behave tag over each scenario of the .feature file and they are translated using the ./resources/issues.yaml
```bash
bugs:
  BUG_001: ...
  BUG_002: ...
  BUG_003: ...

comments:
  COMMENT_001: ...
  COMMENT_002: ...
  COMMENT_003: ...
```
