USE [ShowDotNetIT]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFullName]    Script Date: 05/27/2024 08:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFullName](@FirstName nvarchar(100), @LastName nvarchar(100))
RETURNS NVARCHAR(500)
AS 
BEGIN
	RETURN @FirstName + ' ' + @LastName
END
GO
