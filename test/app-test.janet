(use joy)
(import tester :prefix "" :exit true)
(import "app" :prefix "")

(db/connect (env :database-url))

(deftest
  (test "test the app"
    (let [{:status status} (app {:uri "/" :method :get})]
      (is (= status 200)))))
