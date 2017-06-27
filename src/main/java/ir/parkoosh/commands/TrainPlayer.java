package ir.parkoosh.commands;

import ir.parkoosh.Main;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class TrainPlayer implements Command {
    @Override
    public String getDescription() {
        return "Train players.";
    }

    @Override
    public Result __do() throws Exception {
        Scanner console = new Scanner(System.in);

        Statement statement = Main.getConnection().createStatement();
        String sql = "SELECT employee.* FROM contract,employee, team " +
                "WHERE employee.type != 'dealer' AND employee__fk = employee_pk " +
                "and contract.team_fk =team_pk and team_pk = '" + Main.getTeamID() + "'";
        ResultSet result = statement.executeQuery(sql);

        ArrayList<String> ids = new ArrayList<>();

        System.out.println("Your trainers are :");
        while (result.next()) {
            ids.add(result.getString("employee_pk"));
            System.out.println(result.getString("employee_pk") + "." + result.getString("name") +
                    ", " + result.getString("type") + ", " + result.getString("percent"));
        }

        System.out.println("Enter one of above trainers:");
        String trainerId = console.next();

        if (!ids.contains(trainerId)) {
            System.out.println("You are input wrong number.");
            return null;
        }

        // todo get player list
        statement = Main.getConnection().createStatement();
        sql = "select player.player_pk ,player.name,fitness.* " +
                "from play,player,fitness " +
                "WHERE fitness_pk = player.fitness_fk and player_pk = play.player_fk and team_fk = " + Main.getTeamID();
        result = statement.executeQuery(sql);

        System.out.println("name\t\t body_strength \t\t passing \t\t ball_making \t\t goal_making \t\t shoot_making " +
                "\t\t speed \t\t goal_keeping");

        ids = new ArrayList<>();

        while (result.next()) {
            StringBuilder sb = new StringBuilder();
            ids.add(result.getString("player_pk"));
            sb.append(result.getString("player_pk"))
                    .append("\t\t\t\t")
                    .append(result.getString("name"))
                    .append("\t\t\t\t")
                    .append(result.getString("body_strength"))
                    .append("\t\t\t\t")
                    .append(result.getString("passing"))
                    .append("\t\t\t\t")
                    .append(result.getString("ball_making"))
                    .append("\t\t\t\t")
                    .append(result.getString("goal_making"))
                    .append("\t\t\t\t")
                    .append(result.getString("shoot_making"))
                    .append("\t\t\t\t")
                    .append(result.getString("speed"))
                    .append("\t\t\t\t")
                    .append(result.getString("goal_keeping"))
                    .append("\t\t\t\t");

            System.out.println(sb);
        }

        // todo choose player to train
        System.out.println("Enter one of above player to train:");
        String playerId = console.next();

        if (!ids.contains(playerId)) {
            System.out.println("You are input wrong number.");
            return null;
        }

        // todo find trainer type
        statement = Main.getConnection().createStatement();
        sql = "select employee.type , employee.percent from employee WHERE employee_pk = '" + trainerId + "'";
        result = statement.executeQuery(sql);
        result.next();
        String trainerType = result.getString("type").replace("_trainer", "");
        int percent = result.getInt("percent");


        // todo find player fitness id
        statement = Main.getConnection().createStatement();
        sql = "select player.fitness_fk from player WHERE player_pk = '" + playerId + "'";
        result = statement.executeQuery(sql);
        result.next();
        int fitness_fk = result.getInt("fitness_fk");

        // todo train player
        String query = "{CALL update_" + trainerType + "(?,?)}";
        CallableStatement stmt = Main.getConnection().prepareCall(query);

        stmt.setDouble(1, (double) percent / (double) 100);
        stmt.setInt(2, fitness_fk);
        stmt.execute();


        statement = Main.getConnection().createStatement();
        sql = "select player_pk, player.name , fitness.* from player, fitness WHERE fitness_fk = fitness_pk and player_pk = '"
                + playerId + "'";
        result = statement.executeQuery(sql);
        result.next();

        StringBuilder sb = new StringBuilder();

        sb.append("player_pk :")
                .append(result.getString("player_pk"))
                .append("\t")
                .append("name :")
                .append(result.getString("name"))
                .append("\t")
                .append("body_strength :")
                .append(result.getString("body_strength"))
                .append("\t")
                .append("passing :")
                .append(result.getString("passing"))
                .append("\t")
                .append("ball_making :")
                .append(result.getString("ball_making"))
                .append("\t")
                .append("goal_making :")
                .append(result.getString("goal_making"))
                .append("\t")
                .append("shoot_making :")
                .append(result.getString("shoot_making"))
                .append("\t")
                .append("speed :")
                .append(result.getString("speed"))
                .append("\t")
                .append("goal_keeping :")
                .append(result.getString("goal_keeping"))
                .append("\t");

        System.out.println(sb);

        return null;
    }
}
