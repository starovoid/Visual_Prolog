implement main
    open core, file, stdio

domains
    genre = drama; thriller; fantasy; horror; detective.
    year = integer.
    month = integer.
    day = integer.
    hour = integer.
    minute = integer.
    date = date(year, month, day).
    time = time(hour, minute).

class facts - movies
    % кинотеатр(id, название, адрес, телефон, кол-во мест)
    cinema : (integer Id_c, string Name_c, string Address, string Phone, integer Capacity).
    % Факты о фильмах: фильм(id, название, год выпуска, режиссер, жанр)
    film : (integer Id_m, string Name_m, integer Year, string Director, genre FilmGenre).
    % Факты о показах: показывают(id кинотеатра, id фильма, дата, время, цена билета).
    show : (integer Id_c, integer Id_m, date Date, time Time, integer Price).

class facts
    s : (integer Sum) single.

clauses
    s(0).

class predicates
    % Кинотеатр, показывающий определенный фильм
    cinema_showing_film : (string Name_m) nondeterm.
    %  Адрес кинотеатра, показывающего фильм определенного жанра
    cinema_address_by_genre : (genre Genre) nondeterm.
    % Выручка кинотеатра за билет на определенный фильм
    ticket_price_by_film : (string Name_m) nondeterm.
    % Фильмы, снятые в конкретный год
    film_in_year : (integer Year) nondeterm.
    % Названия всех кинотеатров
    cinema_name : () nondeterm.
    % Суммарная вместимость всех кинотеатров
    total_capacity : () nondeterm.
    % Длина списка
    len : (Lst*) -> integer N.
    % Максимальный элемент списка
    max : (integer* Lst, integer Max [out]) nondeterm.
    % Минимальный элемент списка
    min : (integer* Lst, integer Min [out]) nondeterm.
    % Сумма элементов списка
    sum : (integer* Lst) -> integer S.
    % Среднее списка
    average : (integer* Lst) -> real A determ.
    % Вывод списка
    data : (main::movies*) nondeterm.
    % Список фильмов с указанным жанром
    by_genre : (genre G) -> main::movies* ByGenre nondeterm.
    % Общая вместимость кинотеатров
    sum_capacity : () -> integer Sum.
    % Максимальная цена билета
    max_price : () -> integer Max determ.
    % Минимальная цена билета
    min_price : () -> integer Min determ.

clauses
    len([]) = 0.
    len([_ | T]) = len(T) + 1.

    sum([]) = 0.
    sum([X | T]) = sum(T) + X.

    max([Max], Max).
    max([X, Y | T], Max) :-
        X >= Y,
        max([X | T], Max).
    max([X, Y | T], Max) :-
        X < Y,
        max([Y | T], Max).

    min([Min], Min).
    min([X, Y | T], Min) :-
        X <= Y,
        min([X | T], Min).
    min([X, Y | T], Min) :-
        X > Y,
        min([Y | T], Min).

    average(Lst) = sum(Lst) / len(Lst) :-
        len(Lst) > 0.

    % Вывод данных
    data([X | T]) :-
        write(X),
        nl,
        data(T).

    by_genre(Genre) = ByGenre :-
        film(Id_m, Name, Year, Director, Genre),
        ByGenre = [ film(Id_m, Name, Year, Director, Genre) || film(Id_m, Name, Year, Director, Genre) ].

    sum_capacity() = Sum :-
        Sum = sum([ Capacity || cinema(_, _, _, _, Capacity) ]).

    max_price() = Res :-
        max([ Price || show(_, _, _, _, Price) ], Max),
        Res = Max,
        !.

    min_price() = Res :-
        min([ Price || show(_, _, _, _, Price) ], Min),
        Res = Min,
        !.

    cinema_showing_film(Name_m) :-
        film(Id_m, Name_m, _, _, _),
        show(Id_c, Id_m, _, _, Price),
        cinema(Id_c, Name_c, _, _, _),
        write("Кинотеатр: ", Name_c, ", выручка: ", Price),
        nl,
        fail.

    cinema_address_by_genre(Genre) :-
        show(Id_c, Id_m, _, _, _),
        film(Id_m, _, _, _, Genre),
        cinema(Id_c, _, Address, _, _),
        write("Адрес: ", Address),
        nl,
        fail.

    ticket_price_by_film(Name_m) :-
        film(Id_m, Name_m, _, _, _),
        show(Id_c, Id_m, _, _, Price),
        cinema(Id_c, Name_c, _, _, _),
        write("Кинотеатр: ", Name_c, ", выручка: ", Price),
        nl,
        fail.

    film_in_year(Year) :-
        film(_, Name_m, Year, _, _),
        write("Название фильма: ", Name_m),
        nl,
        fail.

    cinema_name() :-
        cinema(_, Name_c, _, _, _),
        write(Name_c),
        nl,
        fail.

    total_capacity() :-
        cinema(_, _, _, _, Cap),
        s(Sum),
        assert(s(Sum + Cap)),
        fail.
    total_capacity() :-
        s(Sum),
        write("Общая вместимость всех кинотеатров: ", Sum),
        nl.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        write("### Вывод фильмов с жанром drama ###"),
        nl,
        ByGenre = by_genre(drama),
        data(ByGenre),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        write("Общая вместимость всех кинотеатров: ", sum_capacity()),
        nl,
        write("Максимальная цена билета на какой-либо фильм: ", max_price()),
        nl,
        write("Минимальная цена билета на какой-либо фильм: ", min_price()),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).
