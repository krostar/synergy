{
  settings = {
    bump.initial_tag = "v0.1.0";
    changelog = {
      header = ''
        # Changelog

        All notable changes to this project will be documented in this file.

        The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
        and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

      '';

      body = ''
        {% if version -%}
            ## [{{ version | trim_start_matches(pat="v") }}] - {{ timestamp | date(format="%Y-%m-%d") }}
        {% else -%}
            ## [Unreleased]
        {% endif %}
        {% for group, commits in commits | group_by(attribute="group") -%}
            ### {{ group | upper_first }}

            {% for commit in commits -%}
                - {{ commit.message | split(pat="\n") | first | upper_first | trim }}
            {% endfor %}
        {% endfor %}
      '';

      trim = true;

      output = "CHANGELOG.md";
    };
    git = {
      conventional_commits = true;
      filter_unconventional = true;
      filter_commits = true;
      commit_parsers = [
        {
          message = "^[a|A]dd";
          group = "Added";
        }
        {
          message = "^[s|S]upport";
          group = "Added";
        }
        {
          message = "^[r|R]emove";
          group = "Removed";
        }
        {
          message = "^.*: add";
          group = "Added";
        }
        {
          message = "^.*: support";
          group = "Added";
        }
        {
          message = "^.*: remove";
          group = "Removed";
        }
        {
          message = "^.*: delete";
          group = "Removed";
        }
        {
          message = "^test";
          group = "Fixed";
        }
        {
          message = "^fix";
          group = "Fixed";
        }
        {
          message = "^.*: fix";
          group = "Fixed";
        }
        {
          message = "^.*";
          group = "Changed";
        }
      ];
    };
  };
}
