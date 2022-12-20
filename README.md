# hectares
## An IMSLP API library in Common Lisp

The project has a few useful functions so far:
```(gather-people)``` will return a list of all people on IMSLP, stored as ```imslp-person``` objects. 

```(search-people name-string)``` will search through all people for a completely matching name, for instance:

```(search-people "Bach, Johann Sebastian")```

```#<IMSLP-PERSON Bach, Johann Sebastian, https://imslp.org/wiki/Category:Bach,_Johann_Sebastian>```

```(search-works search-string) ``` will search through all works for complete matches:
```HECTARES> (search-works "violin concerto d major")
; Evaluation aborted on NIL.
HECTARES> *search-result*
(#<IMSLP-WORK Concerto No.1 for Violin and Viola in D major (Anzoletti, Marco) https://imslp.org/wiki/Concerto_No.1_for_Violin_and_Viola_in_D_major_(Anzoletti,_Marco)>
 #<IMSLP-WORK Concerto for Violin and Piano in D major, K.Anh.56/315f (Mozart, Wolfgang Amadeus) https://imslp.org/wiki/Concerto_for_Violin_and_Piano_in_D_major,_K.Anh.56/315f_(Mozart,_Wolfgang_Amadeus)>
 #<IMSLP-WORK Concerto for Violin and Cello in F major, D-Dl Mus.2994-O-1 (Anonymous) https://imslp.org/wiki/Concerto_for_Violin_and_Cello_in_F_major,_D-Dl_Mus.2994-O-1_(Anonymous)>
 #<IMSLP-WORK Concerto for Violin and Bassoon in D major (Cattaneo, Francesco Maria) https://imslp.org/wiki/Concerto_for_Violin_and_Bassoon_in_D_major_(Cattaneo,_Francesco_Maria)>
 #<IMSLP-WORK Concerto for Oboe, Violin and Cello in D major (Salieri, Antonio) https://imslp.org/wiki/Concerto_for_Oboe,_Violin_and_Cello_in_D_major_(Salieri,_Antonio)>
 #<IMSLP-WORK Concerto for Oboe and Violin in D major (Valentini, Giuseppe) https://imslp.org/wiki/Concerto_for_Oboe_and_Violin_in_D_major_(Valentini,_Giuseppe)>
 #<IMSLP-WORK Concerto for Harpsichord and Violin in D major (Agthe, Carl Christian) https://imslp.org/wiki/Concerto_for_Harpsichord_and_Violin_in_D_major_(Agthe,_Carl_Christian)>)``` 
etc. 
    I am using bordeaux-threads to add efficiency through multithreading- it is currently set to use 4 cores, go to config.lisp to change ```*cores*``` or likewise ```(setq *cores* number-of-cores)```

##### A joke:

*How much land is used to grow all the trees needed to make all the paper necessary to print all the copies of all the editions of the works of Berlioz?*

Answer: 

*A Hectare of Berlioz*
