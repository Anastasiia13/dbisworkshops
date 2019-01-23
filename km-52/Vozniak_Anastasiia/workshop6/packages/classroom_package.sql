create or replace PACKAGE classroom_package IS

type class_number_table is record(
    class_num classroom.CLASSROOM_NUMBER%TYPE);

type class_table is table of class_number_table;

type building_table is record(
    build classroom.CLASSROOM_building%TYPE);

type build_table is table of building_table;

    FUNCTION get_class(u_email IN users.USER_EMAIL%type) 
    RETURN class_table
    PIPELINED;
        FUNCTION get_build(u_email IN users.USER_EMAIL%type) 
    RETURN build_table
    PIPELINED;

    FUNCTION add_class(
    u_email IN users.USER_EMAIL%type,
        class_num IN classroom.CLASSROOM_NUMBER%TYPE,
         build IN classroom.CLASSROOM_BUILDING%type
    )return VARCHAR2;
    end classroom_package;  
/
create or replace PACKAGE BODY classroom_package IS

    FUNCTION get_class(u_email IN users.user_email%type) 
    RETURN class_table
    PIPELINED
    IS
    TYPE class_cursor_type IS REF CURSOR;
       class_cursor class_cursor_type;
        cursor_data class_number_table;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= 'SELECT * from classroom';

        OPEN class_cursor FOR query_str;

        LOOP
            FETCH class_cursor INTO cursor_data;
            EXIT WHEN (class_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
    END get_class;

    FUNCTION get_build(u_email IN users.user_email%type) 
    RETURN build_table
    PIPELINED
    IS
    TYPE build_cursor_type IS REF CURSOR;
       build_cursor build_cursor_type;
        cursor_data building_table;
        query_str VARCHAR2(1000);
    BEGIN
        query_str:= 'SELECT CLASSROOM_building from classroom';

        OPEN build_cursor FOR query_str;

        LOOP
            FETCH build_cursor INTO cursor_data;
            EXIT WHEN (build_cursor%notfound );
            PIPE ROW ( cursor_data );
        END LOOP;
    END get_build;

    FUNCTION add_class(
    u_email IN users.USER_EMAIL%type,
    class_num IN classroom.CLASSROOM_NUMBER%TYPE,
    build IN classroom.CLASSROOM_BUILDING%type
    )return VARCHAR2 is
    c_count integer;
    class_count_ex exception;
    class_is_ex exception;
    message VARCHAR2(150);
    class_name_ex exception;
    begin
    select count(class_num) into c_count
    from classroom where CLASSROOM_NUMBER=class_num
    and CLASSROOM_BUILDING=build; 

    message:='ok';  
    if c_count=1 then
        raise class_count_ex;
    end if;

    if not REGEXP_LIKE (class_num, '^[0-9]{1,3}[а-я]{0,1}') then
        raise class_name_ex;
    end if;

    insert into classroom(CLASSROOM_NUMBER, CLASSROOM_BUILDING) values(class_num,build);
    COMMIT;
    return message;
     exception
        when class_count_ex then
            message:='Така аудиторія вже існує';
            return message;   
        when class_name_ex then
            message:='Невалідна назва';
            return message; 
    end add_class;




end classroom_package;  

/
    