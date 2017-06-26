package ir.parkoosh.commands;

import ir.parkoosh.Main;
import ir.parkoosh.commands.exceptions.StadiumNotExisted;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class AddTeam implements Command {
    @Override
    public String getDescription() {
        return "Found new team";
    }

    private void checkStadiumID(String id ) throws StadiumNotExisted, SQLException {
        Statement statement = Main.getConnection().createStatement();
        String sql = "SELECT * from stadium WHERE stadium_pk = '" + id + "'";
        ResultSet result = statement.executeQuery(sql);

        int i =0 ;
        while (result.next()) i++;

        if (i != 1)
            throw new StadiumNotExisted();
    }

    @Override
    public Result __do() throws Exception {
        Scanner console = new Scanner(System.in);
        System.out.println("Please enter your team name");
        String teamName = console.next();
        System.out.println("Please enter your stadium id");
        String stadiumID = console.next();

        try {
            checkStadiumID(stadiumID);
        }catch (StadiumNotExisted stadiumNotExisted){
            System.out.println("stadium not exist.");
            return null;
        }

        Statement statement = Main.getConnection().createStatement();
        String sql = "INSERT INTO team (name, stadium_fk) VALUES ('" +teamName + "' , '" + stadiumID + "') ";
        statement.executeUpdate(sql);

        return null;
    }
}
