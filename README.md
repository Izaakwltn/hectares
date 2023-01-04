# hectares
## An IMSLP API library in Common Lisp

The project has a few useful functions so far:

```(gather-people)``` will return a list of all people on IMSLP, stored as ```hectares::person``` objects. Works are likewise stored as ```hectares::work``` objects.

```(search-people name-string)``` will search through all people for a completely matching name, for instance:

!["Bach" Search Results](screenshots/bach-search.png "Bach Search Results")

or

!["Johann Bach" Search Results](screenshots/johann-bach-search.png "Johann Bach Search Results")

```(search-works search-string)``` will search through all works for complete matches (currently, and regrettably, disregards plural instruments (violin vs violins):

![""Bach violin concerto" Search Results](screenshots/bach-violin-concerto-search.png "Bach Violin Concerto Search Results")

I am using bordeaux-threads to add efficiency through multithreading- it is currently set to use 4 cores, go to config.lisp to change ```*cores*``` or likewise ```(setq *cores* number-of-cores)```

```(gather-works)``` somewhat works but there are so many works that it runs at a snail-pace, it may be most useful to bail after an amount of time and reference ```*all-works*``` for what has been collected so far.

Up next is metadata gathering for specified people or works.

## Sometimes it all starts with a joke:

Q- *How much land is used to grow all the trees needed to make all the paper necessary to print all the copies of all the editions of the works of Berlioz?*

A- *A Hectare of Berlioz*
