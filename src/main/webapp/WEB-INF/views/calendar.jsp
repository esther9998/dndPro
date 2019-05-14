<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<meta charset='utf-8' />
<link href='/resources/calendar/core/main.css' rel='stylesheet' />
<link href='/resources/calendar/daygrid/main.css' rel='stylesheet' />
<script src='/resources/calendar/core/main.js'></script>
<script src='/resources/calendar/interaction/main.js'></script>
<script src='/resources/calendar/daygrid/main.js'></script>
<script>

  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var currentDate = new Date();
    var calendar = new FullCalendar.Calendar(calendarEl, {
      plugins: [ 'interaction', 'dayGrid' ],
      header: {
        left: 'prevYear,prev,next,nextYear today',
        center: 'title',
        right: 'dayGridMonth,dayGridWeek,dayGridDay'
      },
      defaultDate: '2019-04-12',
      navLinks: true, // can click day/week names to navigate views
      editable: true,
      eventLimit: true, // allow "more" link when too many events
      events: [
        {
          title: 'All Day Event',
          start: '2019-04-01'
        },
        {
          title: 'Long Event',
          start: '2019-04-07',
          end: '2019-04-10'
        },
        {
          groupId: 999,
          title: 'Repeating Event',
          start: '2019-04-09T16:00:00'
        },
        {
          groupId: 999,
          title: 'Repeating Event',
          start: '2019-04-16T16:00:00'
        },
        {
          title: 'Conference',
          start: '2019-04-11',
          end: '2019-04-13'
        },
        {
          title: 'Meeting',
          start: '2019-04-12T10:30:00',
          end: '2019-04-12T12:30:00'
        },
        {
          title: 'Lunch',
          start: '2019-04-12T12:00:00'
        },
        {
          title: 'Meeting',
          start: '2019-04-12T14:30:00'
        },
        {
          title: 'Happy Hour',
          start: '2019-04-12T17:30:00'
        },
        {
          title: 'Dinner',
          start: '2019-04-12T20:00:00'
        },
        {
          title: 'Birthday Party',
          start: '2019-04-13T07:00:00'
        },
        {
          title: 'Click for Google',
          url: 'http://google.com/',
          start: '2019-04-28'
        }
      ]
    });

    calendar.render();
  });

</script>
<style>

  #calendar {
    margin: 150px auto;
    max-width: 900px;
  }

</style>

  <div id='calendar'></div>

