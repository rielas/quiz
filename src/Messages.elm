module Messages exposing (Msg(..), QuizMsg(..))

import Analytics
import Http
import Model


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | Measured Analytics.Msg


type QuizMsg
    = Next
    | Answer Int
