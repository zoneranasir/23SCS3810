Derive a relational model from each of the ERDs below. 

## Practice #1

```
erdiagram courses
notation=crowsfoot

entity Students {
    id key
    name 
}

entity Courses { 
    number key
    title
}

relationship enrolls_in {
    Students[0..N] -> Courses[0..N]
}
```

![pic1.png](pics/pic1.png)

## Practice #2

```
erdiagram buildings
notation=crowsfoot

entity Buildings {
    name key
    address
}

weak entity Rooms { 
    floor partial-key
    number partial-key
}

weak relationship has {
    Buildings[1] -> Rooms[0..N]
}
```

![pic2.png](pics/pic2.png)

## Practice #3

```
erdiagram candidates
notation=crowsfoot

entity Candidates {
    ssn key
    name 
}

entity JobPositions { 
    number key 
    title 
    department 
}

relationship applies_for {
    Candidates[0..N] -> JobPositions[0..N]
}
```

![pic3.png](pics/pic3.png)
