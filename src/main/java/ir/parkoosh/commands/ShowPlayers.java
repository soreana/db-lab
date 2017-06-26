package ir.parkoosh.commands;

import ir.parkoosh.Main;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class ShowPlayers implements Command {
    @Override
    public String getDescription() {
        return "Show Players info";
    }

    private void extractString(StringBuilder sb , String key , ResultSet result) throws SQLException {
        sb.append(result.getString(key))
                .append("\t\t\t\t");
    }

    @Override
    public Result __do() throws Exception {

        Statement statement = Main.getConnection().createStatement();
        String sql = "select player.name,fitness.* " +
                "from play,player,fitness " +
                "WHERE fitness_pk = player.fitness_fk and player_pk = play.player_fk and team_fk = " + Main.getTeamID();
        ResultSet results = statement.executeQuery(sql);

        System.out.println("name\t\t body_strength \t\t passing \t\t ball_making \t\t goal_making \t\t shoot_making " +
                        "\t\t speed \t\t goal_keeping");

        StringBuilder result = new StringBuilder();

        while(results.next()) {
            StringBuilder sb = new StringBuilder();
            extractString(sb, "name", results);
            extractString(sb, "body_strength", results);
            extractString(sb, "passing", results);
            extractString(sb, "ball_making", results);
            extractString(sb, "goal_making", results);
            extractString(sb, "shoot_making", results);
            extractString(sb, "speed", results);
            extractString(sb, "goal_keeping", results);

            result.append(sb).append("\n");
        }

        System.out.println(result);

        return null;
    }
}
