module Tests exposing (all)

import Expect
import List.Extra
import Model
import Test exposing (..)


scores =
    [ { min = 0
      , description = "<div class=\"result\">Миллениал!</div><div class=\"desc\">Вы&nbsp;что-то слышали о&nbsp;событиях второй половины XX&nbsp;века</div>"
      }
    , { min = 4
      , description = "<div class=\"result\">Поколение X</div><div class=\"desc\">Вы знаете, что происходило во второй половине XX века</div>"
      }
    , { min = 8
      , description = "<div class=\"result\">Леонид Парфенов!</div><div class=\"desc\">Вы&nbsp;смотрели все выпуски программы «Намедни»</div>"
      }
    ]


all : Test
all =
    describe "A Test Suite"
        [ test "1" <|
            \_ ->
                Expect.equal (List.Extra.getAt 0 scores)
                    (Model.getScore scores 0)
        , test "2" <|
            \_ ->
                Expect.equal (List.Extra.getAt 0 scores)
                    (Model.getScore scores 1)
        , test "3" <|
            \_ ->
                Expect.equal (List.Extra.getAt 1 scores)
                    (Model.getScore scores 4)
        , test "4" <|
            \_ ->
                Expect.equal (List.Extra.getAt 2 scores)
                    (Model.getScore scores 9)
        ]
