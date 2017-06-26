package ir.parkoosh.commands;

import ir.parkoosh.Main;

import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class ShowTeamInfo implements Command {
    @Override
    public String getDescription() {
        return "Show team info";
    }

    @Override
    public Result __do() throws Exception{
        Statement statement = Main.getConnection().createStatement();
        String sql = "select * from team WHERE team_pk = " + Main.getTeamID();
        ResultSet result = statement.executeQuery(sql);

        while(result.next()) {
            System.out.println( "Your team name is: " + result.getString("name"));
        }
        return null;
    }
}
