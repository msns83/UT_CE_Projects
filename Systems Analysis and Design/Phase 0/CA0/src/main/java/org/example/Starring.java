package org.example;

public class Starring {
    public String movie ;
    public Date start;
    public Date end;

    Starring(String _movie, Date _start, Date _end){
        if (_movie == null || _movie.trim().isEmpty())
            throw new IllegalArgumentException();
        if (_start == null || _end == null)
            throw new IllegalArgumentException();
        if (_end.compareTo(_start) < 0)
            throw new IllegalArgumentException();

        movie = _movie;
        start = _start;
        end = _end;
    }

    public boolean intersection(Starring other){
        return ((this.start.compareTo(other.end) <= 0) && (other.start.compareTo(this.end) <= 0)) ;
    }

    public int count_days(){
        int total = 1 ;
        Date today = start ;

        while (!today.equals(end)){
            total += 1 ;
            today = today.nextDay();
        }

        return  total;
    }
}
