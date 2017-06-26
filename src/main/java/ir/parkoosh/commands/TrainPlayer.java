package ir.parkoosh.commands;

import ir.parkoosh.Main;

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
        // SELECT employee.*
        //FROM contract,employee, team
        //WHERE employee.type != 'dealer' and team_pk = '1' AND employee__fk = employee_pk and contract.team_fk =team_pk;
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

        System.out.println("Enter one of above trainers:" );
        String temp = console.next();

        if( ! ids.contains(temp)){
            System.out.println("You input wrong number.");
            return null;
        }

        // todo get player list
        // todo choose player to train
        return null;
    }
}
