module Messages exposing (Msg(..), QuizMsg(..))

import Http
import Model


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | GotModel (Result Http.Error Model.Settings)
    | Reset


type QuizMsg
    = Next
    | Answer Int
