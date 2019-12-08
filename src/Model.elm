module Model exposing
    ( Answer
    , Answered(..)
    , Model
    , Question
    , QuizModel
    , Settings
    , State(..)
    , answerQuestion
    , currentQuestion
    , emptyModel
    , getScore
    , nextQuestion
    , settingsDecoder
    , startQuiz
    )

import Array
import Json.Decode as Json
import List.Extra


type Answered
    = NotYet
    | Already Int


type alias QuizModel =
    { currentQuestion : Question
    , answered : Answered
    }


type State
    = Start
    | Quiz QuizModel
    | Finish


type alias Model =
    { state : State
    , correctAnswers : Int
    , questionsSize : Int
    , startPage : String
    , finishPage : String
    , remainingQuestions : List Question
    , scores : List Score
    , trackingId : String
    , clientId : String
    }


type alias Settings =
    { questions : List Question
    , startPage : String
    , finishPage : String
    , scores : List Score
    }


type alias Answer =
    { text : String
    , correct : Bool
    }


type alias Question =
    { description : String
    , answers : List Answer
    , fail : String
    , success : String
    }


type alias Score =
    { min : Int
    , description : String
    }


startQuiz : Model -> Model
startQuiz model =
    let
        size =
            List.length model.remainingQuestions
    in
    case model.remainingQuestions of
        question :: rest ->
            { model
                | state =
                    Quiz
                        { currentQuestion = question
                        , answered = NotYet
                        }
                , remainingQuestions = rest
                , questionsSize = size
            }

        [] ->
            { model | state = Finish }


emptyModel : String -> String -> Model
emptyModel trackingId clientId =
    { state = Start
    , correctAnswers = 0
    , questionsSize = 0
    , startPage = startPage_
    , finishPage = finishPage_
    , remainingQuestions = questions_
    , scores = scores_
    , trackingId = trackingId
    , clientId = clientId
    }


nextQuestion : Model -> Model
nextQuestion model =
    case model.remainingQuestions of
        question :: rest ->
            { model
                | state =
                    Quiz
                        { currentQuestion = question
                        , answered = NotYet
                        }
                , remainingQuestions = rest
            }

        _ ->
            { model | state = Finish }


currentQuestion : Model -> Int
currentQuestion model =
    model.questionsSize - List.length model.remainingQuestions


isCorrect id quiz =
    let
        array =
            Array.fromList quiz.currentQuestion.answers

        answer =
            Array.get id array
    in
    Maybe.withDefault False <| Maybe.map (\a -> a.correct) answer


answerQuestion : Int -> Model -> Model
answerQuestion id model =
    let
        ( state_, correct ) =
            case model.state of
                Quiz quiz ->
                    let
                        quiz_ =
                            if quiz.answered == NotYet then
                                { quiz | answered = Already id }

                            else
                                quiz

                        correct_ =
                            isCorrect id quiz
                    in
                    ( Quiz quiz_, correct_ )

                _ ->
                    ( Finish, False )

        correctAnswers =
            if correct == True then
                model.correctAnswers + 1

            else
                model.correctAnswers
    in
    { model | state = state_, correctAnswers = correctAnswers }


getScore : List Score -> Int -> Maybe Score
getScore scores points =
    let
        sorted =
            List.sortBy .min scores

        lessorequal =
            List.Extra.takeWhile (\score -> score.min <= points) sorted
    in
    List.Extra.last lessorequal


answerDecoder : Json.Decoder Answer
answerDecoder =
    Json.map2 Answer
        (Json.field "text" Json.string)
        (Json.field "correct" Json.bool)


questionDecoder : Json.Decoder Question
questionDecoder =
    Json.map4 Question
        (Json.field "description" Json.string)
        (Json.field "answers" (Json.list answerDecoder))
        (Json.field "fail" Json.string)
        (Json.field "success" Json.string)


scoreDecoder : Json.Decoder Score
scoreDecoder =
    Json.map2 Score
        (Json.field "min" Json.int)
        (Json.field "description" Json.string)


settingsDecoder : Json.Decoder Settings
settingsDecoder =
    Json.map4 Settings
        (Json.field "questions" <| Json.list questionDecoder)
        (Json.field "startPage" Json.string)
        (Json.field "finishPage" Json.string)
        (Json.field "scores" <| Json.list scoreDecoder)


questions_ : List Question
questions_ =
    [ { description = "<p>When Elm first appeared?</p><img alt=\"The Elm tangram\" width=\"120\" src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/800px-Elm_logo.svg.png\">"
      , answers =
            [ { text = "2012"
              , correct = True
              }
            , { text = "2013"
              , correct = False
              }
            , { text = "2014"
              , correct = False
              }
            ]
      , fail = "You're wrong 😔. It appeared at March 30, 2012"
      , success = "You're right! It appeared at March 30, 2012"
      }
    , { description = "How to describe Elm type system?"
      , answers =
            [ { text = "Static, Weak"
              , correct = False
              }
            , { text = "Dynamic, Weak, Inferred"
              , correct = False
              }
            , { text = "Static, Strong, Inferred"
              , correct = True
              }
            ]
      , fail = "You aren't right"
      , success = "You're right"
      }
    , { description = "Who is the inventor of Elm?"
      , answers =
            [ { text = "Guido van Rossum"
              , correct = False
              }
            , { text = "Evan Czaplicki"
              , correct = True
              }
            , { text = "Bjarne Stroustrup"
              , correct = False
              }
            ]
      , fail = "No. The inventor is Evan Czaplicki"
      , success = "You're totally right!"
      }
    , { description = "Does Elm support higher-kinded polymorphism?"
      , answers =
            [ { text = "Yes"
              , correct = False
              }
            , { text = "No"
              , correct = True
              }
            ]
      , fail = "Unfortunately no, unlike Haskell and PureScript"
      , success = "Yeah. That's why Elm does not have a generic map function which works across multiple data structures such as List and Set"
      }
    ]


scores_ : List Score
scores_ =
    [ { min = 0
      , description = "<div class=\"result\">Javascripter!</div><div class=\"desc\">Seems, you don't know anything about Elm</div>"
      }
    , { min = 1
      , description = "<div class=\"result\">Beginner</div><div class=\"desc\">Seems, you're starting programming Elm</div>"
      }
    , { min = 3
      , description = "<div class=\"result\">Evan Czaplicki!</div><div class=\"desc\">You know everything about Elm</div>"
      }
    ]


startPage_ =
    "<h1>Do you know Elm?</h1><p>Let's see how good you know Elm language: the best language for frontend development</p><img alt=\"The Elm tangram\" width=\"120\" src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/800px-Elm_logo.svg.png\">"


finishPage_ =
    "<div id=\"share\"><div class=\"top-block\"><img src=\"https://miro.medium.com/max/660/1*bwSiWbEBA7IyZNyqu2bgBQ.png\" class=\"logo\"><span class=\"commercial\"></span></div><div class=\"inner-container\"><div class=\"middle-block\"><div class=\"title\">How good do you know Elm language?</div><div class=\"share-container\"><div id=\"score\">5/11</div><div id=\"description\"></div></div></div></div></div>"
