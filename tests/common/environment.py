# -*- coding: utf-8 -*-


import re
import csv
import yaml
import json
from datetime import datetime


def before_all(context):
    with open('./settings/params.json', 'r') as params_file:
        context.params = json.load(params_file)
    app_host = context.config.userdata['host'] if 'host' in context.config.userdata else 'localhost'
    context.app_server = f'http://{app_host}:{context.params["port"]}'
    context.create_csv_report = 'csv_report' in context.config.userdata
    if context.create_csv_report:
        execution_timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        csv_report_name = f'./reports/execution_report_{execution_timestamp}.csv'
        field_names = ["Feature", "Scenario", "TestResult", "Date", "TotalDuration", "BUG", "Comment"]
        csv_report = open(csv_report_name, 'w', newline='')
        context.report_writer = csv.DictWriter(csv_report, fieldnames=field_names)
        context.report_writer.writeheader()
        with open('./resources/issues.yaml', 'r') as issues_file:
            context.issues = yaml.safe_load(issues_file)


def before_feature(context, feature):
    context.feature_name = feature.name


def before_scenario(context, scenario):
    context.time_before_scenario = datetime.now()


def after_scenario(context, scenario):
    if context.create_csv_report:
        time_now = datetime.now()
        duration_of_scenario = time_now - context.time_before_scenario
        bugs_ids = [tag for tag in scenario.tags if re.match(r'^BUG_[0-9]+$', tag)]
        bug = bugs_ids[0] if bugs_ids else ""
        comments_ids = [tag for tag in scenario.tags if re.match(r'^COMMENT_[0-9]+$', tag)]
        comment = comments_ids[0] if comments_ids else ""

        context.report_writer.writerow({"Feature": context.feature_name,
                                        "Scenario": scenario.name,
                                        "TestResult": scenario.status.name,
                                        "Date": time_now,
                                        "TotalDuration": duration_of_scenario,
                                        "BUG": bug + ": " + context.issues["bugs"][bug] if bug else "",
                                        "Comment": comment + ": " + context.issues["comments"][comment] if comment else ""})
