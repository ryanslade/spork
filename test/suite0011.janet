(use ../spork/test)
(import ../spork/ev-utils :as eu)
(import ../spork/generators :as generators)

(start-suite 11)

(defn- generator-assert!
  [s]
  (assert (fiber? s))
  (assert (= :new (fiber/status s))))

(def s (generators/from-iterable [1 2 3]))
(generator-assert! s)
(assert (deep= @[1 2 3] (values s)))

(def s (generators/from-iterable @[1 2 3]))
(generator-assert! s)
(assert (deep= @[1 2 3] (values s)))

(def s (generators/from-iterable @[1 2 3]))
(def s2 (generators/from-iterable s))
(generator-assert! s)
(assert (deep= @[1 2 3] (values s2)))

(def s (generators/range 1 10))
(generator-assert! s)
(assert (deep= @[1 2 3 4 5 6 7 8 9] (values s)))

(def s (generators/concat [1] @[2] (generators/from-iterable [3 4 5])))
(generator-assert! s)
(assert (deep= @[1 2 3 4 5] (values s)))

(def s (generators/map inc [1 2 3]))
(generator-assert! s)
(assert (deep= @[2 3 4] (values s)))

(def s (generators/filter odd? [1 2 3]))
(generator-assert! s)
(assert (deep= @[1 3] (values s)))

(def s (generators/take 2 [1 2 3]))
(generator-assert! s)
(assert (deep= @[1 2] (values s)))

(def s (generators/take-while odd? [1 2 3]))
(generator-assert! s)
(assert (deep= @[1] (values s)))

(def s (generators/take-until even? [1 2 3]))
(generator-assert! s)
(assert (deep= @[1] (values s)))

(def s (generators/drop 1 [1 2 3]))
(generator-assert! s)
(assert (deep= @[2 3] (values s)))

(def s (generators/drop-while odd? [1 2 3]))
(generator-assert! s)
(assert (deep= @[2 3] (values s)))

(def s (generators/drop-until even? [1 2 3]))
(generator-assert! s)
(assert (deep= @[2 3] (values s)))

(def s (generators/cycle [1 2 3]))
(generator-assert! s)
(def taken (generators/take 10 s))
(assert (deep= @[1 2 3 1 2 3 1 2 3 1] (values taken)))

(def s (generators/cycle {:a 1 :b 2 :c 3}))
(def taken (generators/take 10 s))
(def taken-array (values taken))
(assert  (= 10 (length taken-array)))
(assert (deep= @[1 2 3] (sorted (distinct taken-array))))

(end-suite)
