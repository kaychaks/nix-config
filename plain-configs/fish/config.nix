
{ pkgs }:
''
set fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish-foreign-env/functions $fish_function_path

${builtins.readFile ./config.fish }
${builtins.readFile ./functions/fish_greeting.fish }
''
