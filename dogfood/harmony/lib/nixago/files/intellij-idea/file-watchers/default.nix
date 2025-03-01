_: tasks: _: {
  output = ".idea/watcherTasks.xml";
  data = {
    project = {
      "@version" = "4";
      component = {
        "@name" = "ProjectTasksOptions";
        TaskOptions =
          builtins.map (
            task: {
              "@isEnabled" = task.enabled;

              option = [
                {
                  "@name" = "name";
                  "@value" = task.name;
                }
                {
                  "@name" = "scopeName";
                  "@value" = task.scope;
                }
                {
                  "@name" = "fileExtension";
                  "@value" = task.fileExtension;
                }
                {
                  "@name" = "workingDir";
                  "@value" = task.workingDir;
                }
                {
                  "@name" = "program";
                  "@value" = task.program;
                }
                {
                  "@name" = "arguments";
                  "@value" = task.arguments;
                }
                {
                  "@name" = "output";
                  "@value" = task.output;
                }

                {
                  "@name" = "runOnExternalChanges";
                  "@value" = "false";
                }
                {
                  "@name" = "checkSyntaxErrors";
                  "@value" = "true";
                }
                {
                  "@name" = "exitCodeBehavior";
                  "@value" = "ERROR";
                }
                {
                  "@name" = "immediateSync";
                  "@value" = false;
                }
                {
                  "@name" = "runOnExternalChanges";
                  "@value" = false;
                }
              ];
            }
          )
          (builtins.filter (task: task.enabled) tasks);
      };
    };
  };
}
