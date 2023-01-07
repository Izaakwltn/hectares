# hectares
## An IMSLP API library in Common Lisp

Hectares is a library for handling data gathering and search operations within the International Music Score Library Project. The [IMSLP API](https://imslp.org/wiki/IMSLP:API) provides two json files, one for works and one for people, and this project is structured accordingly. 

Hectares uses bordeaux-threads to gain speed through multithreading; it is currently set to use 4 cores, go to config.lisp to change ```*cores*``` or simply ```(set-cores number-of-cores)```

## Useful functions

### People
```(gather-people)``` will return a list of all people on IMSLP, stored as ```hectares::person``` objects. Works are likewise stored as ```hectares::work``` objects.

```(search-people name-string)``` will search through all people for a completely matching name, for instance:

!["Bach" Search Results](screenshots/bach-search.png "Bach Search Results")

or

!["Johann Bach" Search Results](screenshots/johann-bach-search.png "Johann Bach Search Results")

The method ```(metadata object)``` uses web-scraping to gather more information than the imslp api provides, for a person it returns a metaperson object. Currently it only adds a person's dates while collecting data accessible with ```#'metaperson-other-data``` (Also can fail with pages that have been deleted.)

!["Composer Metadata Gathered from Charles Alkan Search"](screenshots/composer-metadata.png "Composer Metadata Example")

### Works

```(search-works search-string)``` will search through all works for complete matches (currently, and regrettably, disregards plural instruments (violin vs violins):

!["'Bach violin concerto' Search Results"](screenshots/bach-violin-concerto-search.png "Bach Violin Concerto Search Results")

Metadata can also be gathered for works, and currently contains the year/location of composition and the number of movements. Other data is gathered and is accessible with ```#'metawork-other-data```:
!["Metadata gathered for Bach's Violin Concerto in E Major"](screenshots/work-metadata.png "Bach E Major Metadata")

```(gather-works)``` somewhat works but there are so many works that it runs at a snail-pace, it may be most useful to bail after an amount of time and reference ```*all-works*``` for what has been collected so far.


## A musical joke:

Q- *How much land is used to grow all the trees needed to make all the paper necessary to print all the copies of all the editions of the complete works of Berlioz?*

A- *A Hectare of Berlioz*
