﻿using System;

namespace App.Core.Data.Attributes
{
    public enum PredicateOperation
    {
        /// <summary>
        /// Exact match (string,long,int,double)
        /// </summary>
        Equals = 1,

        /// <summary>
        /// Case insensitive string
        /// </summary>
        Contains = 2,

        /// <summary>
        /// Expects search parameter (from single input) with two values delimited by '-': "DD.MM.YYYY-DD.MM.YYYY" (autogenerated by DatePickers), OR "10-20"
        /// </summary>
        ValueRange = 3,

        /// <summary>
        /// Example:
        /// [PredicateCase(PredicateOperation.InputRange)]
        /// public double Price { get; set; }
        /// expects two search paramenters (from two inputs): Price_From, Price_To
        /// finally will be generated sql code: AND (qry_x."Price" >= 'value of Price_From') AND (qry_x."Price" <= 'value of Price_From')
        /// </summary>
        InputRange = 4,

        /// <summary>
        ///  Raw sql string
        ///  example:
        ///  [PredicateCase(PredicateOperation.Condition, "#value OR (#item.\"ParentId\" IS NULL)")]
        ///  public bool SearchInSubContacts { get; set; }
        ///  #value will be replaced by property(SearchInSubContacts) value
        ///  #item will be replaced by sql query item (alias = "qry_x" in PredicateBuildHelper)
        ///  finally will be generated sql code: AND (TRUE OR qry_x."ParentId" IS NULL)
        /// </summary>
        Condition = 5,

        /// <summary>
        ///  Grouping all properties with PredicateOperation.Overlaps by "Group" and generate OVERLAPS sql operator
        ///  example:
        ///  [PredicateCase(PredicateOperation.Overlaps)]
        ///  public DateTime Date1 { get; set; }
        ///  [PredicateCase(PredicateOperation.Overlaps)]
        ///  public DateTime Date2 { get; set; }
        ///  finally will be generated sql code: AND ((qry_x."Date1", qry_x."Date2") overlaps ('value of Date1', 'value of Date2'))
        ///  
        ///  [PredicateCase(PredicateOperation.Overlaps, Group = "1")]
        ///  public DateTime Date3 { get; set; }
        ///  [PredicateCase(PredicateOperation.Overlaps, Group = "1")]
        ///  public DateTime Date4 { get; set; }
        /// https://www.postgresql.org/docs/9.1/functions-datetime.html
        /// </summary>
        Overlaps = 6
    }

    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
    public class PredicateCase : Attribute
    {
        public PredicateOperation Operation { get; set; }
        public string Condition { get; set; }
        public string Group { get; set; }

        public PredicateCase(PredicateOperation operation = PredicateOperation.Equals, string condition = null)
        {
            Operation = operation;
            Condition = condition;
        }
    }
}

