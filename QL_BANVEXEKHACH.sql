use master
-------------------------Tao CSDL Quan Ly Ben Xe phuc vu cho cac ben xe khach------------------------

/* Kiem tra Database 'QuanLyBenXe' da ton tai chua, neu co ta se xoa va tao moi */
--If Exists (Select name From sysdatabases where name = 'QL_BANVEXEKHACH')
--Drop Database QL_BANVEXEKHACH
Go
-------------Tao Database moi
Create database QL_BANVEXEKHACH
Go
------------Xem thong tin database vua tao
--Exec sp_helpdb QuanLyBenXe
Go
------Chuyen vao database vua tao de su dung
Use QL_BANVEXEKHACH
Go
	
-----------------------------------Tao Bang------------------------------

------------------------------Tabl1.NguoiDung----------------------------


create table XE
(
	MAXE INT IDENTITY(1,1),
	BIENSOXE Nvarchar(15) not null,
	TRANGTHAI Nvarchar(30) CHECK (TRANGTHAI IN (N'Đang hoạt động',N'Đang sửa chữa',N'Dừng hoạt động')),
	MALOAIXE  INT,
)
go
create table LOAIXE
(
	MALOAIXE INT IDENTITY(1,1),
	TENLOAIXE Nvarchar(50) not null,
	SOGHE Int not null
)
Go
create table  VEXE
(
	MAVE  INT IDENTITY(1,1),
	MANV  INT not null,
	MACHUYENXE INT not null,
	TENKH Nvarchar(20) not null, 
	SDT Varchar(10) not null,
	VITRI varchar(3),
	GHICHU Nvarchar(50) default N'Không có ghi chú gì!',
	TINHTRANG NVARCHAR(20) CHECK (TINHTRANG IN (N'Đang giữ chỗ', N'Đã thanh toán'))
)

go
create table TUYENXE
(
	MATUYEN  INT IDENTITY(1,1),
	TENTUYEN Nvarchar(50) not null UNIQUE,
	DIEMXUATPHAT Nvarchar(50) not null,
	DIEMDEN Nvarchar(50) not null,
	BANGGIA float default 0,
	QUANGDUONG int default 0
)
go


create table QUYENTC
(
	MAQUYEN  INT IDENTITY(1,1),
	TENQUYEN Nvarchar(50) not null
)
Go
create table NVBANVE
(
	MANV INT IDENTITY(1,1),
	USERNAME Varchar(50) not null UNIQUE,
	PASSWORD varchar(100) not null,
	TENNV Nvarchar(50) not null,
	NGAYSINH Date ,
	GIOITINH Nvarchar(5),
	DIACHI Nvarchar(50),
	CMND Varchar(12) not null UNIQUE,
	SDT Varchar(10) UNIQUE,
	EMAIL Varchar(30) ,
	TRANGTHAI NVarchar(30) CHECK (TRANGTHAI IN (N'đã nghỉ làm', N'nghỉ phép', N'đang làm việc')),
	MAQUYEN INT default 1

)
go
create table TAIXE	
(
	MATAIXE  INT IDENTITY(1,1),
	TENTAIXE Nvarchar(50) not null,
	NGAYSINH Date,
	GIOITINH Nvarchar(5) ,
	DIACHI Nvarchar(50),
	CMND Varchar(12),
	SDT Varchar(10),
	EMAIL Varchar(30)
)
go
create table CHUYENXE
(
	MACHUYENXE  INT IDENTITY(1,1),
	MATUYEN INT not null,
	MAXE INT not null,
	GIOXUATPHAT DateTime not null,
	GIODEN DateTime not null,
	GHETRONG Int,
	MATAIXE INT not null
)
go



------------------------------------Tao Khoa Chinh----------------------------------------
------------------------------------------------------------------------------------------

go
Alter table XE 
Add constraint pk_XE primary key(MAXE)
go
Alter table LOAIXE
Add constraint pk_LOAIXE primary key(MALOAIXE)

go
Alter table VEXE
Add constraint pk_VEXE primary key(MAVE)

go

Alter table  TUYENXE
Add constraint pk_TUYENXE primary key(MATUYEN)
go
Alter table NVBANVE
Add constraint pk_NVBANVE primary key(MANV)
go
Alter table QUYENTC
Add constraint pk_QUYENTC primary key(MAQUYEN)
go
Alter table TAIXE 
Add constraint pk_TAIXE primary key(MATAIXE)
go
Alter table CHUYENXE 
Add constraint pk_CHUYENXE primary key(MACHUYENXE)	
go
---------------------------------------Tao Khoa Ngoai------------------------------
-----------------------------------------------------------------------------------

go
Alter table VEXE 
Add constraint fk_VEXE_NVBANVE foreign key(MANV) references NVBANVE(MANV)
Go

Alter table VEXE
Add constraint fk_VEXE_CHUYENXE foreign key(MACHUYENXE) references CHUYENXE(MACHUYENXE)
Go


GO
Alter table XE
Add constraint fk_XE_LOAIXE foreign key(MALOAIXE) references LOAIXE(MALOAIXE)
Go
Alter table CHUYENXE 
Add constraint fk_CHUYENXE_XE foreign key(MAXE) references XE(MAXE)
go
Alter table NVBANVE 
Add constraint fk_NVBANVE_QUYENTC foreign key(MAQUYEN) references QUYENTC(MAQUYEN)
go
Alter table CHUYENXE
Add constraint fk_CHUYENXE_TUYENXE foreign key(MATUYEN) references TUYENXE(MATUYEN)
go	
Alter table CHUYENXE
Add constraint fk_CHUYENXE_TAIXE foreign key(MATAIXE) references TAIXE(MATAIXE)
go
-- tạo view 
CREATE VIEW View_XeLoaiXe
AS
SELECT
    X.MAXE,
    X.BIENSOXE,
    X.TRANGTHAI,
    LX.TENLOAIXE,
    LX.SOGHE
FROM
    XE X
JOIN
    LOAIXE LX ON X.MALOAIXE = LX.MALOAIXE;
go
CREATE VIEW View_VeXeTuyenXe
AS
SELECT
    V.MAVE,
    V.TENKH,
    V.SDT,
    T.TENTUYEN,
    CX.GIOXUATPHAT,
    CX.GIODEN,
    V.VITRI,
    V.TINHTRANG
FROM
    VEXE V
JOIN
    CHUYENXE CX ON V.MACHUYENXE = CX.MACHUYENXE
JOIN
    TUYENXE T ON CX.MATUYEN = T.MATUYEN;
go
CREATE VIEW View_NhanVienQuyenTruyCap
AS
SELECT
    NV.USERNAME,
    NV.TENNV,
    NV.NGAYSINH,
    NV.GIOITINH,
    NV.DIACHI,
    NV.CMND,
    NV.SDT,
    NV.EMAIL,
    Q.TENQUYEN
FROM
    NVBANVE NV
JOIN
    QUYENTC Q ON NV.MAQUYEN = Q.MAQUYEN;

go
CREATE VIEW View_TaiXeChuyenXe
AS
SELECT
    TX.TENTAIXE,
    TX.NGAYSINH,
    TX.GIOITINH,
    TX.DIACHI,
    TX.CMND,
    TX.SDT,
    TX.EMAIL,
    CX.GIOXUATPHAT,
    CX.GIODEN
FROM
    TAIXE TX
JOIN
    CHUYENXE CX ON TX.MATAIXE = CX.MATAIXE;
Go
---------------------------------------Tao trigger------------------------------
---------------------------------------------------------------------------------
Go
CREATE TRIGGER TRG_Insert_NVBANVE
ON NVBANVE
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE NVBANVE
    SET TRANGTHAI = COALESCE(i.TRANGTHAI, N'đang làm việc')
    FROM INSERTED i
    WHERE NVBANVE.MANV = i.MANV
      AND i.TRANGTHAI IS NULL;
END;
Go

CREATE TRIGGER tr_ChuyenXe_UpdateGheTrong
ON CHUYENXE
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE C
    SET GHETRONG = L.SOGHE
    FROM CHUYENXE C
    INNER JOIN INSERTED I ON C.MACHUYENXE = I.MACHUYENXE
	INNER JOIN XE X ON X.MAXE = I.MAXE
    INNER JOIN LOAIXE L ON L.MALOAIXE = X.MALOAIXE
END;
go	
CREATE TRIGGER UpdateGHETRONG
ON VEXE
AFTER INSERT, DELETE
AS
BEGIN
 BEGIN TRY
        BEGIN TRAN
    UPDATE CHUYENXE
    SET CHUYENXE.GHETRONG = CHUYENXE.GHETRONG - 1
    FROM CHUYENXE
    INNER JOIN INSERTED ON CHUYENXE.MACHUYENXE = INSERTED.MACHUYENXE;

    UPDATE CHUYENXE
    SET CHUYENXE.GHETRONG = CHUYENXE.GHETRONG + 1
    FROM CHUYENXE
    INNER JOIN DELETED ON CHUYENXE.MACHUYENXE = DELETED.MACHUYENXE;
	 COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
    END CATCH;
END;

Go
CREATE TRIGGER CheckTaiXeTrungThoiGian
ON CHUYENXE
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM CHUYENXE C1
        INNER JOIN CHUYENXE C2 ON C1.MATAIXE = C2.MATAIXE
        WHERE C1.MACHUYENXE <> C2.MACHUYENXE
        AND ((C1.GIOXUATPHAT BETWEEN C2.GIOXUATPHAT AND C2.GIODEN)
             OR (C2.GIOXUATPHAT BETWEEN C1.GIOXUATPHAT AND C1.GIODEN))
    )
    BEGIN
        RAISERROR(N'Tài xê không thể xuất hiện cùng lúc trong nhiều chuyến xe.', 16, 1);
        ROLLBACK TRANSACTION
    END;
END;
go

CREATE TRIGGER CheckGioXuatPhatGioDen
ON CHUYENXE
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM CHUYENXE
        WHERE GIOXUATPHAT > GIODEN
    )
    BEGIN
        RAISERROR(N'thời gian xuất phát phải trước thời gian đến.',16, 1);
        ROLLBACK TRANSACTION
    END;
END;
go

CREATE TRIGGER InsertDefaultGHICHU
ON VEXE
AFTER INSERT,UPDATE
AS
BEGIN
     UPDATE VEXE
    SET GHICHU = N'Không có ghi chú'
    WHERE GHICHU IS NULL;
END;
Go

CREATE TRIGGER CheckChuyenDaChay
ON VEXE
INSTEAD OF INSERT
AS
BEGIN
    
    IF NOT EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN CHUYENXE C ON I.MACHUYENXE = C.MACHUYENXE
        WHERE C.GIOXUATPHAT <= GETDATE()
    )
    BEGIN
        INSERT INTO VEXE (MANV, MACHUYENXE, TENKH,SDT, VITRI, GHICHU, TINHTRANG)
        SELECT MANV, MACHUYENXE, TENKH,SDT, VITRI, GHICHU, TINHTRANG
        FROM INSERTED;
    END
    ELSE
    BEGIN
        RAISERROR(N'Không thể mua vé cho chuyến đã bắt đầu chạy.', 16, 1);
    END;
END;
go

CREATE TRIGGER SetDefaultTinhTrang
ON VEXE
AFTER INSERT
AS
BEGIN
    
    UPDATE VEXE
    SET TINHTRANG = N'Đang giữ chỗ'
    WHERE TINHTRANG IS NULL;
END;


------------------------Nhap du lieu vào bang ---------------------------
-------------------------------------------------------------------------
go
INSERT INTO LOAIXE (TENLOAIXE,SOGHE)
VALUES(N'Thường',41), (N'Luxury',36), (N'Limousine',22),  (N'Xe 29 chỗ',29),(N'Xe 16 chỗ',16);

go
INSERT INTO XE ( BIENSOXE,TRANGTHAI ,MALOAIXE )
VALUES 
( '29A-12345',N'Đang hoạt động', 1),
( '51F-67890',N'Đang hoạt động', 1),
( '63G-54321',N'Đang hoạt động', 1),
( '29A-12345',N'Đang hoạt động', 1),
( '51F-61390',N'Đang hoạt động', 1),
( '63G-31930',N'Đang hoạt động', 1),
( '29A-31912',N'Đang hoạt động', 1),
( '51F-00371',N'Đang hoạt động', 1),
( '63G-13123',N'Đang hoạt động', 1),
( '63G-93121',N'Đang hoạt động', 1),

( '29G-23455',N'Đang hoạt động', 2),
( '32F-77121',N'Đang hoạt động', 2),
( '25G-21092',N'Đang hoạt động', 2),
( '29A-72611',N'Đang hoạt động', 2),
( '51F-88881',N'Đang hoạt động', 2),
( '63G-31930',N'Đang hoạt động', 2),
( '29H-99127',N'Đang hoạt động', 2),
( '31G-21232',N'Đang hoạt động', 2),
( '42F-38171',N'Đang hoạt động', 2),
( '12G-19210',N'Đang hoạt động', 2),

( '25G-31293',N'Đang hoạt động', 3),
( '21G-12393',N'Đang hoạt động', 3),
( '31A-93113',N'Đang hoạt động', 3),
( '22G-23455',N'Đang hoạt động', 3),
( '21D-77121',N'Đang hoạt động', 3),
( '21G-21092',N'Đang hoạt động', 3),
( '12A-18231',N'Đang hoạt động', 3),
( '33F-66319',N'Đang hoạt động', 3),
( '58G-37187',N'Đang hoạt động', 3),
( '19H-77317',N'Đang hoạt động', 3);
go
INSERT INTO TUYENXE (TENTUYEN, QUANGDUONG ,DIEMXUATPHAT, DIEMDEN, BANGGIA)
VALUES 

---An Giang - Sài Gòn
(N'An Giang - Sài Gòn',70,N'Bến xe Chợ Mới', N'Bến xe Miền Tây', 100000),
--- Sài Gòn - An Giang
(N'Sài Gòn - An Giang', 70, N'Bến xe Miền Tây', N'Bến xe Chợ Mới', 100000),
--Hà Tĩnh - Sài Gòn
(N'Hà Tĩnh - Sài Gòn', 700, N'Bến xe Cẩm Xuyên', N'Bến xe Ngã Tư Ga',650000),
--- Sài Gòn - Hà Tĩnh
(N'Sài Gòn - Hà Tĩnh', 700, N'Bến xe Miền Đông', N'Bến xe Hà Tĩnh', 650000),
--Thừa Thiên Huế - Sài Gòn
(N'Thừa Thiên Huế - Sài Gòn', 550, N'97 An Dương Vương', N'Bến xe Ngã Tư Ga', 500000),
--Sài Gòn - Thừa Thiên Huế
(N'Sài Gòn - Thừa Thiên Huế', 550, N'Bến xe Ngã Tư Ga',N'97 An Dương Vương', 500000);

go
INSERT INTO TAIXE (TENTAIXE, NGAYSINH, GIOITINH, DIACHI, CMND, SDT, EMAIL)
VALUES 
(N'Liên Kiên Trung', '1983-06-25', N'Nam', N'Phường Tân Phú, Quận 7, Hồ Chí Minh', '123456789012', '0777910846', 'lienkientrung544@gmail.com'),
(N'Lê Hoàng Quân', '1995-03-15', N'Nam', N'Phường 05, Quận 11, Hồ Chí Minh', '987654321098', '0960783612', 'lehoangquan40@gmail.com'),
(N'Phùng Ðình Nguyên', '1985-11-30', N'Nam', N'Phường 10, Quận 8, Hồ Chí Minh', '456789012345', '0369874512', 'phunginhnguyen181@gmail.com'),
(N'Phùng Thái Học', '1982-02-22', N'Nam', N'Phường Tây Thạnh, Quận Tân Phú, Hồ Chí Minh', '123456789012', '0777910846', 'hocphung2121@gmail.com');
go
INSERT INTO QUYENTC (TENQUYEN)
VALUES 
('user'),
('admin');
Go
INSERT INTO NVBANVE (USERNAME, PASSWORD, TENNV, NGAYSINH, GIOITINH, DIACHI, CMND, SDT, EMAIL, MAQUYEN)
VALUES 
('user1', 'e10adc3949ba59abbe56e057f20f883e', N'Trần Ngọc Tuấn', '1990-05-15', N'Nam', N'Quận 7,TP.HCM', '123456789012', '0123456789', 'user1@email.com', 1),
('user2', 'e10adc3949ba59abbe56e057f20f883e', N'Nhân viên 2', '1985-08-20', N'Nữ', N'Tân Phú,TP.HCM', '987654321098', '0987654321', 'user2@email.com', 1),
('admin1', 'e10adc3949ba59abbe56e057f20f883e', N'Quận trị viên 1', '1975-03-10', N'Nam', N'Tân Bình,TP.HCM', '456789012345', '0369874512', 'admin1@email.com', 2);
go

INSERT INTO CHUYENXE (MATUYEN, MAXE,GIOXUATPHAT, GIODEN, MATAIXE )
VALUES 
(1, 1, '2024-10-28 08:00:00', '2024-10-28 12:00:00', 1),
(2, 2, '2024-10-28 14:30:00', '2024-10-28 18:30:00', 2),
(2,3,  '2024-10-28 09:00:00', '2024-10-30 13:45:00', 3),
(3,12,  '2024-10-28 09:00:00', '2024-10-30 13:45:00', 4);
go

INSERT INTO VEXE (MANV, MACHUYENXE, TENKH,SDT, VITRI, GHICHU,TINHTRANG)
VALUES 
(1, 1, N'Võ Thiên Thảo', '0345274212', 'A1', null,N'Đã thanh toán'),
(1, 2, N'Ánh Việt Hải', '0987312321', 'B2', null,N'Đã thanh toán'),
(2, 4,N'Hoàng Trung Kiên', '0363112111', 'C3', null,N'Đã thanh toán');	
Go
--------------- STRORE PROCEDURE -------------------------------
Create PROC USP_GetQuyen @userName NVARCHAR(50)
As
 Begin
Select QUYENTC.* from QUYENTC,NVBANVE where QUYENTC.MAQUYEN = NVBANVE.MAQUYEN AND NVBANVE.USERNAME = @userName 
END
Create PROC USP_GetAllTuyenXe
As
 Begin
	SELECT DISTINCT T.*
	FROM TUYENXE T
END;

Select * from CHUYENXE
GO

CREATE OR ALTER FUNCTION f_dangnhap(@userName NVARCHAR(50), @matkhau NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    IF NOT EXISTS (
            SELECT 1
            FROM NVBANVE
            WHERE USERNAME = @userName AND PASSWORD = @matkhau
        )
        SET @Result = 0; -- Thông tin đăng nhập không hợp lệ
    ELSE
        SET @Result = 1; -- Thông tin đăng nhập hợp lệ

    RETURN @Result;
END;

go


Create PROC USP_GetAccountByUserName
@userName nvarchar(50)
As
 Begin
	Select * from NVBANVE where userName = @userName
 END;
GO

Create PROC USP_UpdateAccount
@userName NVARCHAR(100),@password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM NVBANVE WHERE USERName = @userName AND Password = @password
	IF (@isRightPass = 1)
	BEGIN
	IF (@newPassword = NULL OR @newPassword ='')
		BEGIN	
			RAISERROR(N'Bạn phải nhập mật khẩu mới trước!', 16, 1);
			ROLLBACK TRANSACTION	
		END
		ELSE
		UPDATE dbo.NVBANVE SET PASSWORD = @newPassword WHERE UserName = @userName
	END
END;

GO
--DROP PROC USP_GetListChuyenXe
Create PROC USP_GetListChuyenXe
AS
Begin 
	SELECT * FROM CHUYENXE
	WHERE CHUYENXE.GIOXUATPHAT > GETDATE();
END;
GO

Create PROC USP_GetNgayXuatPhatFromTuyenXe @maTuyen int
AS
Begin
	SELECT CONVERT(NVARCHAR(10), GIOXUATPHAT, 103) AS NgayThangNam
	FROM CHUYENXE
	WHERE MATUYEN = @maTuyen
	AND GIOXUATPHAT> GETDATE()
	Group by CONVERT(NVARCHAR(10), GIOXUATPHAT, 103)
END;
go
--EXEC USP_GetNgayXuatPhatFromTuyenXe 3
GO
--Drop PROC USP_GetGioFromTuyenXe
Create PROC USP_GetGioFromTuyenXe @maTuyen int,	@NgayThangNam NVARCHAR(10)
AS
Begin
	SELECT CONVERT(NVARCHAR(5), GIOXUATPHAT, 108) AS GioPhut
	FROM CHUYENXE
	WHERE MATUYEN = @maTuyen AND CONVERT(NVARCHAR(10), GIOXUATPHAT, 103) = @NgayThangNam
END;
go
--Exec USP_GetGioFromTuyenXe 1,'28/10/2024'
--DROP PROC USP_GetAllTTVeXe
Create PROC USP_GetAllTTVeXe
AS
Begin
SELECT V.MAVE, V.TENKH,V.SDT,T.TENTUYEN, CX.GIOXUATPHAT,LX.TENLOAIXE,TX.TENTAIXE, V.VITRI, V.TINHTRANG,
 CASE
        WHEN X.MALOAIXE = 1 THEN T.BANGGIA
        WHEN X.MALOAIXE = 2 THEN T.BANGGIA + 150000
        WHEN X.MALOAIXE = 3 THEN T.BANGGIA + 300000
        WHEN X.MALOAIXE = 4 THEN T.BANGGIA + 200000
        WHEN X.MALOAIXE = 5 THEN T.BANGGIA + 150000
        ELSE T.BANGGIA
    END AS BANGGIA
FROM VEXE V
JOIN CHUYENXE CX ON V.MACHUYENXE = CX.MACHUYENXE
JOIN TUYENXE T ON CX.MATUYEN = T.MATUYEN
JOIN XE X ON CX.MAXE = X.MAXE
JOIN LOAIXE LX ON LX.MALOAIXE = X.MALOAIXE 
JOIN TAIXE TX ON TX.MATAIXE = CX.MATAIXE
WHERE CX.GIOXUATPHAT > GETDATE();
END;
Go
CREATE OR ALTER PROCEDURE GetVeXeFiltered
    @Machuyen INT = 0,
    @TenKH NVARCHAR(255) = NULL,
    @SDT NVARCHAR(20) = NULL,
    @MaTuyen INT = 0
AS
BEGIN
    SELECT
        V.MAVE,
        V.TENKH,
        V.SDT,
        T.TENTUYEN,
        CX.GIOXUATPHAT,
        LX.TENLOAIXE,
        TX.TENTAIXE,
        V.VITRI,
        V.TINHTRANG,
        CASE
            WHEN X.MALOAIXE = 1 THEN T.BANGGIA
            WHEN X.MALOAIXE = 2 THEN T.BANGGIA + 150000
            WHEN X.MALOAIXE = 3 THEN T.BANGGIA + 300000
            WHEN X.MALOAIXE = 4 THEN T.BANGGIA + 200000
            WHEN X.MALOAIXE = 5 THEN T.BANGGIA + 150000
            ELSE T.BANGGIA
        END AS BANGGIA
    FROM
        VEXE V
    JOIN
        CHUYENXE CX ON V.MACHUYENXE = CX.MACHUYENXE
    JOIN
        TUYENXE T ON CX.MATUYEN = T.MATUYEN
    JOIN
        XE X ON CX.MAXE = X.MAXE
    JOIN
        LOAIXE LX ON LX.MALOAIXE = X.MALOAIXE
    JOIN
        TAIXE TX ON TX.MATAIXE = CX.MATAIXE
    WHERE
        CX.GIOXUATPHAT > GETDATE()
        AND (@Machuyen = 0 OR V.MACHUYENXE = @Machuyen)
        AND (@TenKH IS NULL OR V.TENKH LIKE N'%' + @TenKH + '%')
        AND (@SDT IS NULL OR V.SDT LIKE '%' + @SDT + '%')
        AND (@MaTuyen = 0 OR T.MATUYEN = @MaTuyen);
END;

Go
CREATE OR ALTER PROCEDURE GetVeXeFilteredByConditions
    @MaVe INT = 0,
    @MaTuyen INT = 0,
    @MaLoaiXe INT = 0,
    @NgayChay NVARCHAR(10) = NULL,
    @TenKH NVARCHAR(255) = NULL,
    @SDT NVARCHAR(20) = NULL,
    @TinhTrang NVARCHAR(50) = NULL
AS
BEGIN
    SELECT
        V.MAVE,
        V.TENKH,
        V.SDT,
        T.TENTUYEN,
        CX.GIOXUATPHAT,
        LX.TENLOAIXE,
        TX.TENTAIXE,
        V.VITRI,
        V.TINHTRANG,
        CASE
            WHEN X.MALOAIXE = 1 THEN T.BANGGIA
            WHEN X.MALOAIXE = 2 THEN T.BANGGIA + 150000
            WHEN X.MALOAIXE = 3 THEN T.BANGGIA + 300000
            WHEN X.MALOAIXE = 4 THEN T.BANGGIA + 200000
            WHEN X.MALOAIXE = 5 THEN T.BANGGIA + 150000
            ELSE T.BANGGIA
        END AS BANGGIA
    FROM
        VEXE V
    JOIN
        CHUYENXE CX ON V.MACHUYENXE = CX.MACHUYENXE
    JOIN
        TUYENXE T ON CX.MATUYEN = T.MATUYEN
    JOIN
        XE X ON CX.MAXE = X.MAXE
    JOIN
        LOAIXE LX ON LX.MALOAIXE = X.MALOAIXE
    JOIN
        TAIXE TX ON TX.MATAIXE = CX.MATAIXE
    WHERE
        CX.GIOXUATPHAT > GETDATE()
        AND (@MaVe = 0 OR V.MAVE = @MaVe)
        AND (@MaTuyen = 0 OR CX.MATUYEN = @MaTuyen)
        AND (@MaLoaiXe = 0 OR X.MALOAIXE = @MaLoaiXe)
        AND (@NgayChay IS NULL OR CONVERT(DATE, CX.GIOXUATPHAT, 103) = CONVERT(DATE, @NgayChay, 103))
        AND (@TenKH IS NULL OR V.TENKH LIKE N'%' + @TenKH + '%')
        AND (@SDT IS NULL OR V.SDT LIKE '%' + @SDT + '%')
        AND (@TinhTrang IS NULL OR V.TINHTRANG = @TinhTrang);
END;

go
CREATE OR ALTER FUNCTION dbo.GetSoVeDaBan(@Nam INT,@Thang INT) RETURNS INT
AS
BEGIN
    DECLARE @SoVeDaBan INT

    SELECT @SoVeDaBan = COUNT(MAVE)
    FROM CHUYENXE
	JOIN TUYENXE ON CHUYENXE.MATUYEN = TUYENXE.MATUYEN
    JOIN VEXE ON CHUYENXE.MACHUYENXE = VEXE.MACHUYENXE
    WHERE TINHTRANG = N'Đã thanh toán' AND YEAR(CHUYENXE.GIODEN) =@Nam AND MONTH(CHUYENXE.GIODEN) =@Thang
    RETURN @SoVeDaBan
END;

CREATE OR ALTER PROCEDURE USP_GetSLVeTheoThang @Nam INT
AS
BEGIN
    -- Tạo bảng tạm
    CREATE TABLE #TempVeDaBan (
        Nam INT,
        Thang INT,
        SoVeDaBan INT
    )

    -- Khai báo biến sử dụng cho cursor
    DECLARE @Thang INT
    DECLARE @SoVeDaBan INT

    -- Khai báo cursor
    DECLARE cursorChuyenXe CURSOR FOR
    SELECT 
        YEAR(CHUYENXE.GIODEN) AS Nam,
        MONTH(CHUYENXE.GIODEN) AS Thang,
		COUNT(VEXE.MAVE) AS SoVeDaBan
    FROM 
        CHUYENXE
    JOIN 
        TUYENXE ON CHUYENXE.MATUYEN = TUYENXE.MATUYEN
	JOIN 
		VEXE ON CHUYENXE.MACHUYENXE = VEXE.MACHUYENXE
    WHERE 
        YEAR(CHUYENXE.GIODEN) = @Nam
	GROUP BY 
     YEAR(CHUYENXE.GIODEN),MONTH(CHUYENXE.GIODEN)

    -- Mở cursor
    OPEN cursorChuyenXe

    -- Fetch dữ liệu từ cursor và chèn vào bảng tạm
    FETCH NEXT FROM cursorChuyenXe INTO @Nam, @Thang,@SoVeDaBan

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #TempVeDaBan (Nam, Thang, SoVeDaBan)
        VALUES (@Nam, @Thang, dbo.GetSoVeDaBan(@Nam,@Thang))

        FETCH NEXT FROM cursorChuyenXe INTO  @Nam, @Thang, @SoVeDaBan
    END
    CLOSE cursorChuyenXe
    DEALLOCATE cursorChuyenXe
    SELECT * FROM #TempVeDaBan
    ORDER BY Thang
    DROP TABLE #TempVeDaBan
END;

Go
Exec USP_GetSLVeTheoThang 2024
go
CREATE OR ALTER FUNCTION dbo.GetDoanhThu(@Nam INT,@Thang INT) RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @DoanhThu DECIMAL(18, 2)

    SELECT @DoanhThu = SUM(
        CASE
            WHEN X.MALOAIXE = 1 THEN T.BANGGIA
            WHEN X.MALOAIXE = 2 THEN T.BANGGIA + 150000
            WHEN X.MALOAIXE = 3 THEN T.BANGGIA + 300000
            WHEN X.MALOAIXE = 4 THEN T.BANGGIA + 200000
            WHEN X.MALOAIXE = 5 THEN T.BANGGIA + 150000
            ELSE T.BANGGIA
        END
		)
    FROM CHUYENXE
    JOIN TUYENXE T ON CHUYENXE.MATUYEN = T.MATUYEN
    JOIN VEXE ON CHUYENXE.MACHUYENXE = VEXE.MACHUYENXE
	JOIN XE X ON X.MAXE = CHUYENXE.MAXE
    WHERE VEXE.TINHTRANG = N'Đã thanh toán' AND MONTH(CHUYENXE.GIODEN) = @Thang and YEAR(CHUYENXE.GIODEN) = @Nam 
    RETURN @DoanhThu
END;
CREATE OR ALTER PROCEDURE USP_GetDoanhThuTheoThang @Nam INT
AS
BEGIN
    CREATE TABLE #TempDoanhThu (
		Nam INT,
        Thang INT,
        DoanhThu DECIMAL(18, 2)
    )
    DECLARE @Thang INT
    DECLARE @DoanhThu DECIMAL(18, 2)
    DECLARE cursorDoanhThu CURSOR FOR
    SELECT 
		YEAR(CHUYENXE.GIODEN) AS Nam,
        MONTH(CHUYENXE.GIODEN) AS Thang,
        SUM(TUYENXE.BANGGIA) AS DoanhThu
    FROM 
        CHUYENXE
    JOIN 
        TUYENXE ON CHUYENXE.MATUYEN = TUYENXE.MATUYEN
    JOIN 
        VEXE ON CHUYENXE.MACHUYENXE = VEXE.MACHUYENXE
    WHERE 
        VEXE.TINHTRANG = N'Đã thanh toán' AND YEAR(CHUYENXE.GIODEN) = @Nam
    GROUP BY 
        YEAR(CHUYENXE.GIODEN),MONTH(CHUYENXE.GIODEN)
    OPEN cursorDoanhThu
    FETCH NEXT FROM cursorDoanhThu INTO @Nam,@Thang, @DoanhThu
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #TempDoanhThu (Nam,Thang, DoanhThu) VALUES (@Nam,@Thang, dbo.GetDoanhThu(@Nam,@Thang))
        FETCH NEXT FROM cursorDoanhThu INTO @Nam,@Thang, @DoanhThu
    END
    CLOSE cursorDoanhThu
    DEALLOCATE cursorDoanhThu
    SELECT * FROM #TempDoanhThu
    ORDER BY Thang
    DROP TABLE #TempDoanhThu
END;


Go
EXEC USP_GetDoanhThuTheoThang 2024
Go
--DROP PROCEDURE USP_GetLoaiXeFormMaChuyen
create PROCEDURE USP_GetLoaiXeFormMaChuyen @maChuyen INT
AS
BEGIN
SELECT
	LOAIXE.*
FROM
    CHUYENXE
    JOIN XE ON CHUYENXE.MAXE = XE.MAXE
    JOIN LOAIXE ON XE.MALOAIXE = LOAIXE.MALOAIXE
WHERE
    CHUYENXE.MACHUYENXE = @maChuyen	
END;
Go



--DROP  PROCEDURE USP_LoaiXeFromGioXuatPhat 
create PROCEDURE USP_LoaiXeFromGioXuatPhat @matuyen int,@xuatphat varchar(20)
AS
BEGIN

 SET @xuatphat = REPLACE(@xuatphat, '/', '-') + ':00';
SELECT
    LOAIXE.*
FROM
    CHUYENXE
    JOIN XE ON CHUYENXE.MAXE = XE.MAXE
    JOIN LOAIXE ON XE.MALOAIXE = LOAIXE.MALOAIXE
WHERE
    CHUYENXE.MATUYEN = @matuyen 
    AND CHUYENXE.GIOXUATPHAT =CONVERT(DATETIME, @xuatphat, 103);
END;
Exec USP_LoaiXeFromGioXuatPhat 1, '28/10/2024 08:00'
Go
--Exec USP_GetAllTTVeXe

--DROP PROCEDURE USP_TaiXeFromTuyenXe

create PROCEDURE USP_TaiXeFromTuyenXe @matuyen int,@maloaixe int ,@xuatphat varchar(20)
AS
BEGIN
SET @xuatphat = REPLACE(@xuatphat, '/', '-') + ':00';
SELECT DISTINCT
    TX.*
FROM
    CHUYENXE CX
    JOIN XE X ON CX.MAXE = X.MAXE
	JOIN TAIXE TX ON CX.MATAIXE = TX.MATAIXE
WHERE
    CX.MATUYEN = @matuyen	
    AND GIOXUATPHAT = CONVERT(DATETIME, @xuatphat, 103)
    AND X.MALOAIXE = @maloaixe
END;
Go

--DROP PROCEDURE GetBIEnSoByMaTuyenAndGioXuatPhat
create PROCEDURE GetBIEnSoByMaTuyenAndGioXuatPhat @matuyen int,@maloaixe int ,@xuatphat varchar(20) ,@MaTaixe int
AS
BEGIN
SET @xuatphat = REPLACE(@xuatphat, '/', '-') + ':00';
SELECT DISTINCT
    X.BIENSOXE
FROM
    CHUYENXE CX
    JOIN XE X ON CX.MAXE = X.MAXE
	JOIN TAIXE TX ON CX.MATAIXE = TX.MATAIXE
WHERE
    CX.MATUYEN = @matuyen	
    AND GIOXUATPHAT = CONVERT(DATETIME, @xuatphat, 103)
    AND X.MALOAIXE = @maloaixe
	AND CX.MATAIXE = @MaTaixe
END;
go
create PROCEDURE USP_DSVeXe @matuyen int,@maloaixe int, @xuatphat varchar(20),@mataixe int
AS
BEGIN

 SET @xuatphat = REPLACE(@xuatphat, '/', '-') + ':00';
SELECT
	V.*
	FROM VEXE V
	INNER JOIN CHUYENXE CX ON V.MACHUYENXE = CX.MACHUYENXE
	INNER JOIN XE X ON X.MAXE = CX.MAXE
	INNER JOIN LOAIXE LX ON LX.MALOAIXE = X.MALOAIXE
WHERE
    CX.MATUYEN = @matuyen 
	AND CX.MATAIXE = @mataixe
    AND CX.GIOXUATPHAT =CONVERT(DATETIME, @xuatphat, 103)
	AND LX.MALOAIXE = @maloaixe
END;
go
CREATE PROCEDURE GetMACHUYEN
    @MALOAIXE INT,
    @MATUYEN INT,
    @xuatphat varchar(20),
    @MATAIXE INT
AS
BEGIN
 SET @xuatphat = REPLACE(@xuatphat, '/', '-') + ':00';
    SELECT MACHUYENXE
    FROM CHUYENXE
	Inner join XE ON XE.MAXE = CHUYENXE.MAXE
    WHERE	MALOAIXE = @MALOAIXE
        AND MATUYEN = @MATUYEN
        AND  GIOXUATPHAT = CONVERT(DATETIME, @xuatphat, 103)
        AND MATAIXE = @MATAIXE;
END;

--Select* from LOAIXE
--Select * from XE
--Select * from TUYENXE
--Select * from QUYENTC
--Select * from NVBANVE
--Select * from TAIXE
--Select * from CHUYENXE
--Select * from VEXE

Select * from View_XeLoaiXe
Select * from View_VeXeTuyenXe
Select * from View_NhanVienQuyenTruyCap
Select * from View_TaiXeChuyenXe


GetMACHUYEN 4,1,'18/02/2024 15:00',2