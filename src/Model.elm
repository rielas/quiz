module Model exposing (Answer, Answered(..), Model, Question, QuizModel, Settings, State(..), answerQuestion, emptyModel, getScore, nextQuestion, settingsDecoder, startQuiz)

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
    = Init
    | Start
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
emptyModel trackingId clientId  =
    { state = Init
    , correctAnswers = 0
    , questionsSize = 0
    , startPage = ""
    , finishPage = ""
    , remainingQuestions = []
    , scores = []
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
