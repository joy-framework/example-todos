(use joy)
(import tester :prefix "" :exit true)
(import "src/app" :prefix "")

(deftest
  (test "test the app"
    (is (= 200
           (do
             (db/connect (env :database-url))
             (let [response (app {:uri "/" :method :get})]
               (get response :status)))))))
