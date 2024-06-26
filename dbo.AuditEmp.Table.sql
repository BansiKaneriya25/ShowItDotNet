USE [ShowDotNetIT]
GO
/****** Object:  Table [dbo].[AuditEmp]    Script Date: 05/27/2024 08:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditEmp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[OldFirstName] [nvarchar](50) NOT NULL,
	[NewFirstName] [nvarchar](50) NOT NULL,
	[OldLastName] [nvarchar](50) NOT NULL,
	[NewLastName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_AuditEmp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
