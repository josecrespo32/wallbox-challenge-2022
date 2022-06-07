## Getting started ##

### Context ###

Tests are automated/defined using behave, you can find more info here: https://behave.readthedocs.io/en/stable/#

Before running the tests start the app in localhost by using the instructions provided in: https://github.com/josecrespo32/wallbox-challenge-2022/blob/main/README.md

To be able to run the tests you need Python3 installed, a virtualenv is recommended too.

### Test plans ###

- Integration:

    Includes every combination for every endpoint, not only the most common or complex ones. It will ensure the correct behavior of the endpoints in corner cases, with auth errors, etc.

- End to end:

    Just includes the more common operations, the ones that includes a complex flow that will take place in a normal usage of the app.

### Running the tests ###

Once you have everything prepared just activate the venv and from the commandline run:

```
pip install -r requirements.txt
```

And then, to run all the tests just use:

```
behave --no-capture -t ~@skip
```

If you only wanted to run e2e tests try:

```
behave --tags=e2e --no-capture -t ~@skip
```

If you only wanted to run integration tests try:

```
behave --tags=integration --no-capture -t ~@skip
```

If you only wanted to run the tests on a feature try:

```
behave --include=health --no-capture -t ~@skip
```

where health must be the name or part of the name of the feature.

The output must be similar to:

```
behave --include=health --no-capture -t ~@skip


Feature: Health endpoint feature # features/health.feature:1
  As a user I want to be able to check if the app is up and running
  Scenario: Call the health endpoint and verify answer is ok  # features/health.feature:4
    Given the request host "http://localhost:3000"            # common/api.py:37 0.000s
    And the request path "/"                                  # common/api.py:47 0.000s
    And the request headers                                   # common/api.py:58 0.000s
      | header_name | header_value     |
      | accept      | application/json |
    When I make a "GET" request                               # common/api.py:81 0.016s
    Then status code is "200"                                 # common/api.py:102 0.000s
    And the response headers are                              # common/api.py:122 0.000s
      | header_name                 | header_value                    |
      | access-control-allow-origin | *                               |
      | content-length              | 59                              |
      | content-type                | application/json; charset=utf-8 |
      | x-powered-by                | Express                         |
    And json response body is the following                   # common/api.py:112 0.000s
      """
      {
        "message": "Wallbox Challenge API REST is up and running!"
      }
      """

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
7 steps passed, 0 failed, 0 skipped, 0 undefined
Took 0m0.017s
```

### Next steps ###

What to do next:

1. Automate the tests that only have the header.
2. Group more steps to improve tests readability.
3. Move test data to config files and encrypt passwords.
4. Run app and tests with docker in order to simplify setup and run process.
5. Include a jenkins file in repository in order to run tests on CI and track the changes in the pipeline.
6. Create performance tests and include them in CI. This will ensure there will be no performance problems when developing new features.
7. Include security tests in CI using for example Kiuwan.
