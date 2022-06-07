from common.api import check_api_health
from behave import use_fixture

def before_tag(context, tag):
    if tag == "fixture.check_api_health":
        use_fixture(check_api_health, context)