(declare-project
  :name "todos"
  :description ""
  :dependencies [{:repo "https://github.com/joy-framework/joy" :tag "283766b785e8ed8d59803a3c8be56d61bd693e8e"}
                 {:repo "https://github.com/joy-framework/tester" :tag "c14aff3591cb0aed74cba9b54d853cf0bf539ecb"}]
  :author ""
  :license ""
  :url ""
  :repo "")

(declare-executable
  :name "todos"
  :entry "main.janet")

(phony "server" []
  (do
    (os/shell "pkill -xf 'janet main.janet'")
    (os/shell "janet main.janet")))

(phony "watch" []
  (do
    (os/shell "pkill -xf 'janet main.janet'")
    (os/shell "janet main.janet &")
    (os/shell "fswatch -o src | xargs -n1 -I{} ./watch")))

