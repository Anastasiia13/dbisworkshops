set serveroutput on
begin
--����������� ������ �� ������������
select * from table(record_package.get_records('ivanov@mail.com'));
exec record_package.add_record('ivanov@mail.com','1002', '01-12-2018 09:30' );
exec record_package.update_record ('2008','20-12-2018 09:30');
exec record_package.del_rec('2006');

exec user_package.register('�������','�����','��������','������','petrov@gmail.com','123456');
select * from table(user_package.login('petrov@gmail.com','123456'));
exec user_package.update_user('�����','��������','�������','petrov@gmail.com');
exec user_package.del_user('petrov@gmail.com');

--����������� ������������ ���������
select * from table(consultation_package.get_cons_list('boris_1@gmail.com'));
exec  consultation_package.add_cons('boris_1@gmail.com','���','505','12','28-12-2018 09:30','28-12-2018 11:30');
exec consultation_package.update_consult ('���','505','12','28-12-2018 10:00','28-12-2018 11:30','1006');
exec consultation_package.del_cons('1006');


--����������� ������ ��������
select * from table(wishlist_package.get_wish('fed123@gmail.com'));
exec wishlist_package.add_wish('���� ����������', '28-12-2018 11:30','boris_1@gmail.com','ivanov@mail.com');
exec wishlist_package.update_wish('���� ����������', '27-12-2018 12:30','boris_1@gmail.com','5');
exec wishlist_package.del_wish('5');
/