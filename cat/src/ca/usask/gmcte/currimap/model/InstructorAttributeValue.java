package ca.usask.gmcte.currimap.model;

// Generated Dec 3, 2011 11:40:19 AM by Hibernate Tools 3.2.4.GA

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;

/**
 * Program generated by hbm2java
 */
@SuppressWarnings("serial")
@Entity
@Table(name = "instructor_attribute_value")
public class InstructorAttributeValue implements java.io.Serializable
{

	private int id;
	private String value;
	private Instructor instructor;
	private InstructorAttribute attribute;

	public InstructorAttributeValue()
	{
	}


	@Id @GeneratedValue
	@Column(name = "id", unique = true, nullable = false)
	public int getId()
	{
		return this.id;
	}

	public void setId(int id)
	{
		this.id = id;
	}


	@Column(name = "value", nullable = false, length = 50)
	@NotNull
	@Length(max = 50)
	public String getValue()
	{
		return value;
	}


	public void setValue(String value)
	{
		this.value = value;
	}

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "instructor_attribute_id")
	public InstructorAttribute getAttribute()
	{
		return attribute;
	}


	public void setAttribute(InstructorAttribute attribute)
	{
		this.attribute = attribute;
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "instructor_id")
	public Instructor getInstructor()
	{
		return instructor;
	}


	public void setInstructor(Instructor instructor)
	{
		this.instructor = instructor;
	}
}