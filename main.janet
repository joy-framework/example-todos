(use joy)
(use ./src/app)


(defn main [&]
  (db/connect (env :database-url))
  (server app 9001)
  (db/disconnect))
