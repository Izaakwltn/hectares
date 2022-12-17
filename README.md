# hectares
## An IMSLP API library in Common Lisp

The project is in its earliest stages, and currently only has two useful tools fully functioning:

```(gather-people)``` will return a list of all people on IMSLP, stored as ```imslp-person``` objects. 

and ```(search-people full-name)``` will search through all people for a matching name, for instance:

```(search-people "Bach, Johann Sebastian")```

```#<IMSLP-PERSON Bach, Johann Sebastian, https://imslp.org/wiki/Category:Bach,_Johann_Sebastian>```

I've been adding in multi-threaded approaches to try to manage the huge quantities of items.

##### A joke:

*How much land is used to grow all the trees needed to make all the paper necessary to print all the copies of all the editions of the works of Berlioz?*

Answer: 

*A Hectare of Berlioz*
