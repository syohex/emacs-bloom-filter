# Bloom filter implementation in Emacs Lisp [![travis badge][travis-badge]][travis-link]

## Sample code

``` lisp
(let ((bfilter (bloom-filter 100 0.01)))
    (cl-loop for i from 1 to 50
             do
             (bloom-filter-add bfilter i))
    (bloom-filter-search bfilter 1)   ;; => t
    (bloom-filter-search bfilter 50)  ;; => t
    (bloom-filter-search bfilter 51)) ;; => In most case, nil
```

## Interfaces

#### `(bloom-filter keys error-rate)`

Returns bloom filter instance whose false positive is `error-rate`.

#### `(bloom-filter-add bfilter object)`

Add object to filter

#### `(bloom-filter-search bfilter object)`

Search object from `bfilter`.

## References
- https://en.wikipedia.org/wiki/Bloom_filter
- http://www.perl.com/pub/2004/04/08/bloom_filters.html

[travis-badge]: https://travis-ci.org/syohex/emacs-bloom-filter.svg
[travis-link]: https://travis-ci.org/syohex/emacs-bloom-filter
