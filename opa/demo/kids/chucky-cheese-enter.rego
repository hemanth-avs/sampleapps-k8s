package chucky.cheese.enter

default is_there_an_adult = false

is_there_an_adult {
    heights := input.kids[_].height 
    heights >= 40

    weights := input.kids[_].weight 
    weights >= 40

}

is_there_a_baby[msg] {

    heights := input.kids[_].height 
    heights <= 10

    weights := input.kids[_].weight 
    weights <= 10

    msg := "There is a Baby in the Group"
}
