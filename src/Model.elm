module Model exposing (Answer, Answered(..), Model, Question, QuizModel, State(..), answerQuestion, emptyModel, nextQuestion, questionDecoder, setQuestions)

import Array
import Json.Decode as Json


type Answered
    = NotYet
    | Already Int


type alias QuizModel =
    { currentQuestion : Question
    , remainingQuestions : List Question
    , answered : Answered
    }


type State
    = Start
    | Quiz QuizModel
    | Finish


type alias Model =
    { state : State
    , correctAnswers : Int
    , questionsNumber : Int
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


setQuestions : Model -> List Question -> Model
setQuestions model questions =
    let
        state_ =
            case questions of
                question :: rest ->
                    Quiz
                        { currentQuestion = question
                        , remainingQuestions = rest
                        , answered = NotYet
                        }

                [] ->
                    Finish
    in
    { state = state_
    , correctAnswers = 0
    , questionsNumber = List.length questions
    }


emptyModel : Model
emptyModel =
    { state = Start, correctAnswers = 0, questionsNumber = 0 }


nextQuestion : Model -> Model
nextQuestion model =
    let
        state_ =
            case model.state of
                Quiz quiz ->
                    case quiz.remainingQuestions of
                        question :: rest ->
                            Quiz
                                { currentQuestion = question
                                , remainingQuestions = rest
                                , answered = NotYet
                                }

                        _ ->
                            Finish

                _ ->
                    Finish
    in
    { model | state = state_ }


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
