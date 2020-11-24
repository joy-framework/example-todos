(use joy)
(use ./app)

(defn main [&]
  (db/connect (env :database-url))
  (server app (env :port))
  (db/disconnect))
