package chucky.cheese.play

default kid1_play = true

kid1_play {
    heights := input.kids[1].height 
    heights >= 20

    weights := input.kids[1].weight 
    weights >= 20
}
