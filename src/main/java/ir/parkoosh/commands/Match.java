package ir.parkoosh.commands;

import ir.parkoosh.Main;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Created by sinakashipazha on 2017/6/27 AD.
 */
public class Match implements Command{
    @Override
    public String getDescription() {
        return "Challenge another team.";
    }

    @Override
    public Result __do() throws Exception {
        // todo get competitors

        Statement statement = Main.getConnection().createStatement();
        String sql = "SELECT team.* FROM team " +
                "WHERE team_pk != " + Main.getTeamID();
        ResultSet results = statement.executeQuery(sql);

        System.out.println("Your Competitors are:");

        StringBuilder sb = new StringBuilder();

        ArrayList<String> ids = new ArrayList<>();

        while(results.next()) {
            ids.add(results.getString("team_pk"));
            sb.append(results.getString("team_pk"))
                    .append(". ")
                    .append(results.getString("name"))
                    .append("\n");
        }

        System.out.println(sb);
        System.out.println("Choose your competitor:");
        Scanner console = new Scanner(System.in);

        String competitorId = console.next();

        if(! ids.contains(competitorId)){
            System.out.println("You are input wrong number.");
            return null;
        }

        // todo match
        String query = "{? =CALL play_game(?,?)}";
        CallableStatement stmt = Main.getConnection().prepareCall(query);

        stmt.registerOutParameter(1, Types.INTEGER);
        stmt.setInt(2, Integer.parseInt(Main.getTeamID()));
        stmt.setInt(3, Integer.parseInt(competitorId));
        stmt.execute();

        int gameResult = stmt.getInt(1);

        if(gameResult == 0)
            System.out.println("Draw");
        else if (gameResult < 0 )
            System.out.println("You lost.");
        else
            System.out.println("You win.");

        return null;
    }
}
