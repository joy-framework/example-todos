(use joy)


(defn link-to [s & params]
  [:a {:href (url-for ;params)} s])


(defn form-to [s & params]
  (form-for params
    [:input {:type "submit" :value s}]))

