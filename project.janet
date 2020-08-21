(declare-project
  :name "todos"
  :description ""
  :dependencies ["https://github.com/joy-framework/joy"]
  :author "Sean Walker"
  :license "MIT"
  :url "https://github.com/joy-framework/example-todos"
  :repo "https://github.com/joy-framework/example-todos")

(declare-executable
  :name "todos"
  :entry "main.janet")

(phony "server" []
  (os/shell "janet main.janet"))

(phony "watch" []
  (os/shell "find . -name '*.janet' | entr -r -d janet main.janet"))
