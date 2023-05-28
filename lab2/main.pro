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

clauses
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
        write("### Названия всех кинотеатров ###"),
        nl,
        cinema_name(),
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        write("Введите год, чтобы узнать, какие фильмы в нем были сняты: "),
        nl,
        Y = read(),
        film_in_year(Y),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        write("Введите жанр фильма: "),
        G = read(),
        G = hasDomain(genre, G),
        cinema_address_by_genre(G),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        write("### Цены билетов на фильм 'Достать ножи' ### "),
        nl,
        ticket_price_by_film("Достать ножи"),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../data.txt", movies),
        total_capacity(),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).
