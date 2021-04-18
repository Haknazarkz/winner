long time = java.lang.System.currentTimeMillis();
			
			ResultSet rs = stmt.executeQuery("SELECT * FROM pkgStudent.getCleverStudents(" + teacher_id + ",'"+course_code+ "'"+")");
			
			long time2 =  java.lang.System.currentTimeMillis() - time;
