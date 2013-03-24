module Gutenberg
  class BookParser

    def initialize(file, chapters)
      @file = file
      @chapters = chapters.reverse.map{|c| ChapterText.new(c)}
      @next = ChapterText.null()
      @current = ChapterText.null()
      @parsed = []
    end

    def parse
      @next = get_next_chapter()
      self.paragraphs().each do |paragraph|
        break if paragraph.end_of_book?
        if paragraph.has_text?
          if @next.begins_with?(paragraph)
            start_next_chapter(paragraph) 
          else
            @current.add(paragraph)
          end
        end
      end 
      return @parsed
    end

    def start_next_chapter(paragraph)
      @current = @next
      @current.title = paragraph.text
      @parsed << @current if !@current.is_null?
      @next = get_next_chapter()
    end
    
    def paragraphs
      file_text = @file.read()
      paragraphs = file_text.split("\n\n")
      return paragraphs.map{ |p| ParagraphText.new(p) }
    end

    def get_next_chapter
      return @chapters.empty? ? ChapterText.null() : @chapters.pop()
    end

  end

  class MobyDick < BookParser
    
    def initialize()
      super(get_file(), get_chapters())
    end

    def get_file()
      return File.new('moby.txt', 'r')
    end

    def get_chapters()
      chapters = [] 
      chapters << 'ETYMOLOGY.'
      chapters << 'EXTRACTS (Supplied by a Sub-Sub-Librarian).'
      135.times.each do |i|
        chapters << "CHAPTER #{i+1}."
      end
      chapters << 'Epilogue'
      return chapters
    end

  end


  class ChapterText

    NULL = "Null.Object"

    attr_reader :paragraphs
    attr_accessor :title
    
    def initialize(header)
      @header = header
      @title = header
      @paragraphs = []
    end

    def begins_with?(text)
      return text.starts_with?(@header)
    end

    def add(paragraph)
      @paragraphs << paragraph
    end

    def is_null?
      return @header == NULL
    end

    def self.null()
      return ChapterText.new(NULL) 
    end
    
  end

  class ParagraphText
    
    attr_reader :text

    def initialize(text)
      @text = text.strip()
    end

    def has_text?
      return !@text.empty?
    end

    def starts_with?(token)
      return @text.starts_with?(token)
    end
      
    def end_of_book?
      return starts_with?("*** END")
    end

  end


  def parse_moby_dick()
    chapters = MobyDick.new().parse()
    i = 0
    chapters.each do |c|
      chapter = Chapter.new(:name => c.title, :position => i += 1)
      x = 0
      c.paragraphs.each do |p|
        chapter.paragraphs.build(:text => p.text, :position => x += 1)
      end 
      chapter.save()
    end
  end
end
