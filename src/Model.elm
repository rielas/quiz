module Model exposing (Entry, Model, emptyModel)


type alias Model =
    Entry


type alias Entry =
    { description : String
    , answers : List String
    , correct : Int
    }


emptyModel =
    { description = "<p>«Это проект „Намедни. Наша эра“. События, люди, явления, определившие образ жизни, то, без чего нас невозможно представить, еще труднее&nbsp;— понять».</p><p>Когда произошло событие, о&nbsp;котором говорит Леонид Парфенов?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xuqr?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
    , answers = [ "<span>1987</span><div>13%</div>", "1989", "1991" ]
    , correct = 0
    }
