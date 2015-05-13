import java.sql.*;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class Roles {

    Connection con;
    int roleNum = 2;
    int userNum = 2;
    int privNum = 3;
    static String curr_user;
    static int line_num = 1;
    public Roles() {
        try {
            Class.forName( "oracle.jdbc.driver.OracleDriver" );
        }
        catch ( ClassNotFoundException e ) {
            e.printStackTrace();
        }
        try {
            con =
                DriverManager.getConnection("jdbc:oracle:thin:@claros.cs.purdue.edu:1524:strep","choi257", "wiZwp1di" );
        }
        catch ( SQLException e ){
            e.printStackTrace();
        }
    }
    public void login(String username, String password, BufferedWriter bw){
        String query = "Select UserName, Password from Users where UserName = '" + username + "' and password = '" + password + "'";
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            if(rs.next()){
                bw.write("Login successful");
                bw.newLine();
                curr_user = username; 
                //System.out.println("curr_user: " + username);
            }else{
                bw.write("Invalid login");
                bw.newLine();
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void createRole(String RoleName, String encKey) {
        String update = "insert into Roles values(" + roleNum + ", '" + RoleName + "', '" + encKey + "')";
        try {
            Statement stmt = con.createStatement();
            stmt.executeUpdate(update);
            roleNum++;
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void createUser(String username, String password) {
        String update = "insert into Users values(" + userNum + ",'" + username + "', '" + password + "')";
        try {
            Statement stmt = con.createStatement();
            stmt.executeUpdate(update);
            userNum++;
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void grantRole(String UserName, String RoleName) {
        String query = "Select UserId from Users where UserName = '" + UserName + "'";
        int UserId = 0;
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while(rs.next()){
                UserId = rs.getInt("UserId");
            }
            query = "Select RoleId from Roles where RoleName = '" + RoleName + "'";
            rs = stmt.executeQuery(query);
            while( rs.next()){
                int RoleId = rs.getInt( "RoleId" );
                String update =  "insert into UserRoles values(" + UserId + ", " + RoleId + ")";
                stmt.executeUpdate(update);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
    public void grantPrivilege(String PrivName, String RoleName, String TableName){
        String query = "Select RoleId from Roles where RoleName = '" + RoleName + "'";
        int RoleId = 0;
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while( rs.next()){
                RoleId = rs.getInt( "RoleId" );
            }
            query = "Select PrivId from Privileges where PrivName = '" + PrivName + "'";
            rs = stmt.executeQuery(query);
            while(rs.next()){
                int PrivId = rs.getInt( "PrivId" );
                String update =  "insert into RolePrivileges values(" + RoleId + ", '" + TableName + "', " + PrivId + ")";
                stmt.executeUpdate(update);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
    public void revokePrivilege(String PrivName, String RoleName, String TableName){
        String query = "Select RoleId from Roles where RoleName = '" + RoleName + "'";
        String delete = "";
        int RoleId = 0;
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while( rs.next()){
                RoleId = rs.getInt( "RoleId" );
            }
            query = "Select PrivId from Privileges where PrivName = '" + PrivName + "'";
            rs = stmt.executeQuery(query);
            while(rs.next()){
                int PrivId = rs.getInt( "PrivId" );
                delete =  "Delete from RolePrivileges where RoleId = " + RoleId + " and TableName = '" + TableName + "' and PrivId = " + PrivId;
                //System.out.println("delete: " + delete);
                stmt.executeUpdate(delete);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
    public boolean isPrivilege(String TableName, String PrivName){
        String query = "Select UserId from Users where UserName = '" + curr_user + "'";
        int UserId = 0;
        int RoleId = 0;
        int PrivId = 0;
        boolean bool = false;
        Statement stmt2;
        ResultSet rs2 = null;
        String query2;
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while( rs.next()){
                UserId = rs.getInt( "UserId" );
            }

            query = "Select privId from Privileges where PrivName = '" + PrivName + "'";
            rs = stmt.executeQuery(query);
            while(rs.next()){
                PrivId = rs.getInt( "PrivId" );
            }

            query = "Select RoleId from UserRoles where UserId = " + UserId ;
            rs = stmt.executeQuery(query);
            stmt2 = con.createStatement();

            while(rs.next()){
                RoleId = rs.getInt( "RoleId" );
                query2 = "Select PrivId from RolePrivileges where RoleId = " + RoleId + "and TableName = '" + TableName + "' and PrivId = " + PrivId;
                rs2 = stmt2.executeQuery(query2);
                while(rs2.next()){
                    bool = true;
                }
            }
            rs2.close();
            rs.close();
            stmt2.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bool; 
    }
    public void insertValue(String TableName, String Values, int columnNo, String RoleName, BufferedWriter bw ){
        String[] parts;
        String[] first;
        String[] last;
        String query = "";
        String update = "";
        int RoleId = 0;
        String key = "";
        if(isPrivilege(TableName, "INSERT")){
            if(columnNo > 0){
                if(TableName.equals("Course")){
                    parts = Values.split(",");
                    first = parts[0].split("\\("); //first[1]
                    last = parts[3].split("\\)");  //last[0]
                    query = "Select RoleId, EncryptionKey from Roles where RoleName = '" + RoleName + "'";
                    try {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            RoleId = rs.getInt( "RoleId" );
                            key = rs.getString( "EncryptionKey" );

                        }
                        if(columnNo == 1){
                            update =  "insert into Course values('" +  VigEncrypt(first[1], key) + "', '" + parts[1] + "', '" + parts[2] + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";
                        }else if(columnNo == 2){
                            update =  "insert into Course values('" +  first[1] + "', '" + VigEncrypt(parts[1], key) + "', '" + parts[2] + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";

                        }else if(columnNo == 3){
                            update =  "insert into Course values('" +  first[1] + "', '" + parts[1] + "', '" + VigEncrypt(parts[2], key) + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";

                        }else if(columnNo == 4){
                            update =  "insert into Course values('" + first[1] + "', '" + parts[1] + "', '" + parts[2] + "', '" + VigEncrypt(last[0], key) + "', " + columnNo + ", " + RoleId + ")";

                        }
                        //System.out.println("update: "+update);
                        stmt.executeUpdate(update);
                        rs.close();
                        stmt.close();
                        bw.write("Row inserted successfully");
                        bw.newLine();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }else{
                    parts = Values.split(",");
                    first = parts[0].split("\\(");
                    last = parts[1].split("\\)");
                    query = "Select RoleId, EncryptionKey from Roles where RoleName = '" + RoleName + "'";
                    try {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            RoleId = rs.getInt( "RoleId" );
                            key = rs.getString( "EncryptionKey" );
                        }
                        if(columnNo == 1){
                            update = "insert into " + TableName + " values('" + VigEncrypt(first[1], key) + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";   
                        }else if(columnNo == 2){
                            update = "insert into " + TableName + " values('" + first[1] + "', '" + VigEncrypt(last[0], key) + "', " + columnNo + ", " + RoleId + ")";
                        }
                        //System.out.println("update: "+update); 
                        stmt.executeUpdate(update);
                        rs.close();
                        stmt.close();
                        bw.write("Row inserted successfully");
                        bw.newLine();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }else{
                if(TableName.equals("Courses")){
                    parts = Values.split(",");
                    first = parts[0].split("\\("); //first[1]
                    last = parts[3].split("\\)");  //last[0]
                    query = "Select RoleId from Roles where RoleName = '" + RoleName + "'";
                    try {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            RoleId = rs.getInt( "RoleId" );
                        }      
                        update = "insert into Course values('" + first[1] + "', '" + parts[1] + "', '" + parts[2] + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";
                        stmt.executeUpdate(update);
                        rs.close();
                        stmt.close();
                        bw.write("Row inserted successfully");
                        bw.newLine();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }else{
                    parts = Values.split(",");
                    first = parts[0].split("\\(");
                    last = parts[1].split("\\)");
                    query = "Select RoleId from Roles where RoleName = '" + RoleName + "'";
                    try {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            RoleId = rs.getInt( "RoleId" );
                        }
                        update = "insert into " + TableName + " values('" + first[1] + "', '" + last[0] + "', " + columnNo + ", " + RoleId + ")";
                        stmt.executeUpdate(update);
                        rs.close();
                        stmt.close();
                        bw.write("Row inserted successfully");
                        bw.newLine();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }

            }
        }else{
            try{
                bw.write("Authorization failure");
                bw.newLine();
            }catch( Exception e){
                e.printStackTrace();
            }
        }
    }
    public void getTable(String TableName,BufferedWriter bw) {
        String query = "Select * from " + TableName;
        Statement stmt2;
        ResultSet rs2 = null;
        String query2 = "";
        String key = "";
        int col_num = 0;
        int RoleId = 0;
        int UserId = 0;
        int enc = 0;
        boolean isOwner = false;
        if(isPrivilege(TableName, "SELECT")){
        try {
            if(TableName.equals("Course")){
                col_num = 4;
                bw.write("CName, DName, CDesc, MainTextBook");
                bw.newLine();
            }else{
                col_num = 2;
                if(TableName.equals("Department")){
                    bw.write("DName, Location");
                    bw.newLine();
                }else{
                    bw.write("SName, SLevel");
                    bw.newLine();
                }
            }
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                isOwner = false;
                enc = rs.getInt ( "EncryptedColumn" );
                if(enc == 0){
                    for(int i = 1; i <= col_num; i++){
                        if(i < col_num ){
                            bw.write(rs.getString(i) + ", ");
                        }else{
                            bw.write(rs.getString(i));
                            bw.newLine();
                        }
                    }
                }else{
                    query2 = "Select UserId from Users where UserName = '" + curr_user + "'";
                    stmt2 = con.createStatement();
                    rs2 = stmt2.executeQuery(query2);
                    while(rs2.next()){
                        UserId = rs2.getInt( "UserId" );
                    }
                    query2 = "Select OwnerRole from " + TableName;
                    rs2 = stmt2.executeQuery(query2);
                    while(rs2.next()){
                        RoleId = rs2.getInt( "OwnerRole" );
                    }
                    query2 = "Select UserId from UserRoles where UserId = " + UserId + "and RoleId = " + RoleId;
                    rs2 = stmt2.executeQuery(query2);
                    while(rs2.next()){
                        isOwner = true;
                    }
                    query2 = "Select EncryptionKey from Roles where RoleId = " + RoleId;
                    rs2 = stmt2.executeQuery(query2);
                    while(rs2.next()){
                        key = rs2.getString( "EncryptionKey" );
                    }

                    for(int i = 1; i <= col_num; i++){
                        if(i < col_num ){
                            if( i == enc ){
                               // System.out.println("Decrypt key: " + key + "enc: " + enc);
                                if(isOwner){
                                    bw.write(VigDecrypt(rs.getString(i), key) + ", ");
                                }else{
                                    bw.write(rs.getString(i) + ", ");
                                }
                            }else{
                                    bw.write(rs.getString(i) + ", ");
                            }
                        }else{
                            if( i == enc){
                                if(isOwner){
                                    bw.write(VigDecrypt(rs.getString(i), key));
                                    bw.newLine();
                                }else{
                                    bw.write(rs.getString(i));
                                    bw.newLine();
                                }
                            }else{
                                bw.write(rs.getString(i));
                                bw.newLine();
                            }
                        }
                    }
                    rs2.close();
                    stmt2.close();
                }
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        }else{
            try{
            bw.write("Authorization failure");
            bw.newLine();
            }catch(IOException e){
                e.printStackTrace();
            }
        }
    }
    public String VigEncrypt(String plain, String key) {
        String rs = "";
        plain = plain.toUpperCase();
        for (int i = 0, j = 0; i < plain.length(); i++) {
            char c = plain.charAt(i);
            rs += (char)((c + key.charAt(j) - 2 * 'A') % 26 + 'A');
            j = ++j % key.length();
        }
        return rs;
    }

    public String VigDecrypt(String cipher, String key) {
        String rs = "";
        cipher = cipher.toUpperCase();
        for (int i = 0, j = 0; i < cipher.length(); i++) {
            char c = cipher.charAt(i);
            rs += (char)((c - key.charAt(j) + 26) % 26 + 'A');
            j = ++j % key.length();
        }
        return rs;
    }
    public static void main(String[] args) {
        Roles sdb = new Roles();
        String readFile = args[0];
        String writeFile = args[1];
        String[] parts;
        String line = null;
        try{
            FileReader fileReader = new FileReader(readFile);
            BufferedReader br = new BufferedReader(fileReader);
            FileWriter fileWriter = new FileWriter(writeFile);
            BufferedWriter bw = new BufferedWriter(fileWriter);

            while((line = br.readLine()) != null) {
                bw.write(line_num + " : " + line);
                parts = line.split(" ");
                if(!parts[0].equals("QUIT")){
                    bw.newLine();
                }
                if(parts[0].equals("LOGIN")){
                    //System.out.println("LOGIN");
                    sdb.login(parts[1],parts[2], bw);
                }else if(parts[0].equals("CREATE")){
                    //System.out.println("CREATE");
                    if(curr_user.equals("admin")){
                        if(parts[1].equals("ROLE")){
                            sdb.createRole(parts[2], parts[3]);
                            bw.write("Role created successfully");
                            bw.newLine();
                        }else if(parts[1].equals("USER")){
                            sdb.createUser(parts[2], parts[3]);
                            bw.write("User created successfully");
                            bw.newLine();
                        }
                    }else{
                        bw.write("Authorization failure");
                        bw.newLine();
                    }
                }else if(parts[0].equals("GRANT")){
                    //System.out.println("GRANT");
                    if(curr_user.equals("admin")){
                        if(parts[1].equals("ROLE")){
                            sdb.grantRole(parts[2],parts[3]);
                            bw.write("Role assigned successfully");
                            bw.newLine();
                        }else if(parts[1].equals("PRIVILEGE")){
                            sdb.grantPrivilege(parts[2], parts[4], parts[6]);
                            bw.write("Privilege granted successfully");
                            bw.newLine();
                        }
                    }else{
                        bw.write("Authorization failure");
                        bw.newLine();
                    }
                }else if(parts[0].equals("SELECT")){
                    //System.out.println("SELECT");
                    sdb.getTable(parts[3],bw);
                }else if(parts[0].equals("REVOKE")&&parts[1].equals("PRIVILEGE")){
                    //System.out.println("REVOKE");
                    if(curr_user.equals("admin")){
                        sdb.revokePrivilege(parts[2], parts[4], parts[6]);
                        bw.write("Privilege revoked successfully");
                        bw.newLine();
                    }else{
                        bw.write("Authorization failure");
                        bw.newLine();
                    }
                }else if(parts[0].equals("INSERT")){
                    //System.out.println("INSERT");
                    sdb.insertValue(parts[2], parts[3], Integer.parseInt(parts[5]), parts[6], bw );           
                }else if(parts[0].equals("QUIT")){
                    break;
                }
                line_num++;
                bw.newLine();
            }
            br.close();
            bw.close();
        }catch(FileNotFoundException ex) {
            System.out.println(
                    "Unable to open file '" + readFile + "'");                
        }
        catch(IOException ex) {
            System.out.println(
                    "Error reading file '" + readFile + "'");                   
        }
    }
}
